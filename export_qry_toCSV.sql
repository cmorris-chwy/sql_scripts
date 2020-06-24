--http://confluence.dbvis.com/display/UG100/Exporting+Query+Results
@export on;
@export set filename="c:\Users\cmorris10\Downloads\Products.csv";
@export set CsvColumnDelimiter=",";
select * from products limit 10;
@export off;