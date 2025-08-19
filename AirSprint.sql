--  CREATING DATABASE OBJECT FOR AirSprint --

/*In creating database objects or model the order is important due to the relationship between primary and foreign key
just like the parent-child relationship. there can not be a child without first the parent*/



Create  table Account(
Id                          varchar2 (255),
Fl3xx_Id__c                 varchar2(255) not null,
Name                        clob null,
Primary_Contact__c          varchar2 (255) Not null,
Aircraft_Type_Owned__c      varchar2 (255) null,
Aircraft_Ownership__c       number(7),
Lease_Renewal_Date__c       date,
Aircraft_Type_Owned_2_c     varchar2 (255),
Aircraft_Ownership_2__c     number (7),
Lease_Renewal_Date_2__c     date,
Aircraft_Type_Owned_3__c    varchar2 (255),
Aircraft_Ownership_3__c     number (7),
Lease_Renewal_Date_3__c     date,
CONSTRAINT Pk_Account primary key (Id),
CONSTRAINT UniqueKeyFl3xxId unique (Fl3xx_Id__c),
CONSTRAINT UniqueKeyContact unique (Primary_Contact__c)
);





Create table Opportunity(
Id                      varchar2 (255),
AccountId               varchar2 (255),
CreatedDate             date,
Aircraft_Type__c        varchar2 (255),
Hours__c                number (7,2),
IsWon                   number (1),
Status                  generated always as (case IsWon when 1 then 'ContractWon' else 'ContractNotWon' end) Virtual,
CONSTRAINT Pk_Opportunity primary key (Id),
CONSTRAINT Fk_AccountOpportunity foreign key (AccountId) references Account(Id),
CONSTRAINT Ck_IsWon check(IsWon in (1,0))
);


create table Aircraft(
Registration__c     varchar2 (255),	
Aircraft_Model__c    varchar2 (255),
Name                varchar2 (255),
CONSTRAINT Pk_Aircraft primary key (Name)
);



Create table Asset(
Opportunity__c      varchar2 (255) Default 'UnDecided',
Name                varchar2 (55),
AccountId           varchar2 (255),
Ownership__c        number (7,2),
Annual_Hours__c     number (7,2),
CONSTRAINT Fk_OpportunityAsset foreign key (Opportunity__c) references Opportunity(Id),
CONSTRAINT Fk_AircraftAsset foreign key (Name) references Aircraft(Name)
);



Create table Contact(
Id	            varchar2 (255),
Name            varchar2 (255),
CONSTRAINT Pk_ContactAccount primary key (Id), 
CONSTRAINT Fk_ContactAccount foreign key (Id) references Account(Primary_Contact__c)
);


create table FlightA(
flightId        varchar2(255),
accountId       varchar2(255),
customerId      varchar2(155),
accountName     varchar2 (255),
Destination     generated always as (realAirportFrom ||'-'||realAirportTo) virtual,
realAirportFrom varchar2 (255) Default 'NotRetrieved',
realAirportTo   varchar2 (255) Default 'NotRetrieved',
eta             timestamp,
etd             timestamp,
TotalTimeUsed   generated always as (round(extract(hour from (eta-etd))+(extract(minute from(eta-etd))/60),2))virtual,
CONSTRAINT Pk_Flight primary key (flightId),
CONSTRAINT Fk_FlightAccount foreign key (accountId) references account(Fl3xx_Id__c)
);


create table Invoice(
INVUNIQ         varchar2 (255),
ORDNUMBER       varchar2 (255),
CUSTOMER        varchar2 (155),
BILNAME         clob,
COMMENTING      nclob,
INVDATE         date,
INVNUMBER       varchar2 (255),
APPROVELMT      number (15,5),
FLIGHTID        varchar2 (155),
CONSTRAINT Pk_Invoice primary key (INVUNIQ), 
CONSTRAINT Fk_InvoiceAccount foreign key (CUSTOMER) references Account(Fl3xx_Id__c ),
CONSTRAINT Fk_FlightInvoice foreign key (FLIGHTID) references FlightA(flightId)
);


select * from flighta;


create or replace view SummaryReport as 
With filteredtable as (select  distinct
DBMS_LOB.SUBSTR(a.name, 255) "Account Name",
c.Name "Contact Name" ,
a.Fl3xx_Id__c "Account Number", 
sysdate "Summary Date",
a.Lease_Renewal_Date__c "Anniversary Date",
ass.Ownership__c "Ownership %", 
ass.Ownership__c*ass.Annual_Hours__c "Hours Purchased", 
opp.Hours__c "Total Hours BF" , 
fl.TotalTimeUsed " Flight Time Used",
ass.Name || '-' || opp.Aircraft_Type__c Aircraft,
case 
when opp.Aircraft_Type__c in ('Citation CJ2+','Citation CJ3+') then 'CJ'
when opp.Aircraft_Type__c in ('Legacy 450', 'Legacy 500', 'Praetor 450', 'Praetor 500') then 'Legacy'
else null end "Aircraft Group"
from account a
inner join opportunity opp on a.Id = opp.AccountId
inner join asset ass on opp.Id = ass.Opportunity__c
inner join flighta fl on a.Fl3xx_Id__c = fl.accountid
inner join contact c on a.Primary_Contact__c = c.Id)

select * from filteredtable
where "Aircraft Group" = 'CJ';

commit;

select * from invoice;


Create or replace view FlightSummaryMarch as 
with flightSummary as (select distinct
inv.invuniq Invoice_Number_I,
trunc(fl.eta) Date_I,
ar.Name Aircraft_Registration_I,
fl.TotalTimeUsed Flight_Time_I,
case 
when trunc(fl.eta) = trunc(fl.etd) then 'Yes'
else 'No' end Same_Day_Return_I,
fl.destination Destination_I,
inv.approvelmt Amount_I, 
DBMS_LOB.SUBSTR(inv.commenting,7000) Comment_I
from invoice inv
join flighta fl on inv.flightid = fl.flightid
join account a on fl.Accountid = a.Fl3xx_Id__c
join opportunity opp on a.Id = opp.accountid
join asset ass on opp.Id = ass.opportunity__c
join aircraft ar on ass.Name = ar.Name)

select * from flightSummary
where extract( month from date_I) = 3 and extract( year from date_I) = 2025 ;


select  * from flightsummarymarch ;




