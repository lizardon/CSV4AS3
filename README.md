CSV4AS3 is a CSV library for Actionscript that has been ported from Apache Commons CSV

Advantages of this library include:
* Ability to parse incrementally without the need to read entire file into memory
* Support for custom CSV format settings
* Support for handling escapes and comments
* Includes a CSV printer
* Supports UTF8 compatible text formats

Getting Started - Parsing a CSV File

Step 1: Create and open a IDataInput object such as a FileStream

    var file:File = new File("C:\\Users\\userdir\\test.csv");
    var input:FileStream = new FileStream();
    input.open(file, FileMode.READ);


Step 2: Create and Configure A CSVParser:

    // in this case the CSV file has a header
    var parser:CSVParser = new CSVParser(input, CSVFormat.buildDefaultWithHeader());
    var headerMap:Object = parser.getHeaderMap(); 

Step 3: Iterate over the records

    var record:CSVRecord;
    while(parser.hasNext())
    {
      record = parser.next();
 
      for (var columnName:String in headerMap)
      {
        trace(columnName + ": " + record.getValueByName(columnName));
      }
    }


Alternatively parser.getRecords() will return an Array of CSVRecords of all the remaining rows in the file without needing to iterate.

Step 4: Close the input source

    input.close();
