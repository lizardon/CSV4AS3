/*
* Licensed to the Apache Software Foundation (ASF) under one or more
* contributor license agreements.  See the NOTICE file distributed with
* this work for additional information regarding copyright ownership.
* The ASF licenses this file to You under the Apache License, Version 2.0
* (the "License"); you may not use this file except in compliance with
* the License.  You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

/*
 *       *******************************************************
 *         This software is a derivative work of the original  
 *         Apache Software Foundation project Commons CSV.     
 *         It has been ported from the original Java code      
 *         to Actionscript by Lizardon Software in 2013        
 *       *******************************************************
 */

package com.lizardon.csv4as3
{
	import flash.utils.IDataOutput;

	public class CSVPrinter
	{
		protected var _writer:BufferedWriter;
		protected var _format:CSVFormat;
		
		protected var newRecord:Boolean = true;
		
		public function CSVPrinter(output:IDataOutput, format:CSVFormat=null, charSet="utf-8")
		{
			_writer = new BufferedWriter(output, charSet);
			_format = format == null ? CSVFormat.buildDefault() : format;
		}
		
		public function println():void
		{
			_writer.appendString(_format.getRecordSeparator());
			newRecord = true;
		}
		
		public function flush():void
		{
			_writer.flush();
		}
		
		public function printRecord(values:Array):void
		{
			//trace("printRecord columns: " + values.length);
			for (var i:int=0; i<values.length; i++)
			{
				print(values[i]);
			}
			println();
		}
		
		public function printComment(comment:String):void
		{
			if(!_format.isCommentingEnabled())
			{
				return;
			}
			if(!newRecord)
			{
				println();
			}
			_writer.appendString(_format.getCommentStart());
			_writer.appendChar(Constants.SP);
			for(var i:int=0; i<comment.length; i++)
			{
				var char:Number = comment.charCodeAt(i);
				switch(char)
				{
					case Constants.CR:
						if(i + 1 < comment.length() && comment.charCodeAt(i + 1) == Constants.LF)
						{
							i++;
						}
					case Constants.LF:
						println();
						_writer.appendString(_format.getCommentStart());
						_writer.appendChar(Constants.SP);
						break;
					default:
						_writer.appendChar(char);
						break;
				}
			}
			println();
		}
		
		protected function printString(object:Object, value:String, offset:int, len:int):void
		{
			if(!newRecord)
			{
				_writer.appendString(_format.getDelimiter());
			}
			if(_format.isQuoting())
			{
				printAndQuote(object, value, offset, len);
			}
			else if (_format.isEscaping())
			{
				printAndEscape(value, offset, len);
			}
			else
			{
				_writer.appendString(value, offset, offset + len);
			}
			newRecord = false;
		}
		
		protected function printAndEscape(value:String, offset:int, len:int):void
		{
			var start:int = offset;
			var pos:int = offset;
			var end:int = offset + len;
			
			var delim:Number = _format.getDelimiter().charCodeAt();
			var escape:Number = _format.getEscape().charCodeAt();
			
			while (pos < end)
			{
				var char:Number = value.charCodeAt(pos);
				if(char == Constants.CR || char == Constants.LF || char == delim || char == escape)
				{
					if(pos > start)
					{
						_writer.appendString(value, start, pos);
					}
					if(char == Constants.LF)
					{
						char = 'n'.charCodeAt();
					}
					else if (char == Constants.CR)
					{
						char = 'r'.charCodeAt();
					}
					
					_writer.appendChar(escape);
					_writer.appendChar(char);
					
					start = pos + 1;
				}
				
				pos++;
			}
			
			if( pos > start)
			{
				_writer.appendString(value, start, pos);
			}
		}
		
		protected function printAndQuote(object:Object, value:String, offset:int, len:int):void
		{
			var quote:Boolean = false;
			var start:int = offset;
			var pos:int = offset;
			var end:int = offset + len;
			
			var delimChar:Number = _format.getDelimiter().charCodeAt();
			var quoteChar:Number = _format.getQuoteChar().charCodeAt();
			
			var quotePolicy:Quote = _format.getQuotePolicy();
			if(quotePolicy == null)
			{
				quotePolicy = Quote.MINIMAL;
			}
			
			var char:Number;
			
			switch (quotePolicy)
			{
				case Quote.ALL:
					quote = true;
					break;
				case Quote.NON_NUMERIC:
					quote = !(object is Number)
					break;
				case Quote.NONE:
					printAndEscape(value, offset, len);
					return;
				case Quote.MINIMAL:
					if (len <= 0)
					{
						if(newRecord)
						{
							quote = true;
						}
					}
					else
					{
						char = value.charCodeAt(pos);
						
						if (newRecord && (char < '0'.charCodeAt() || 
							(char > '9'.charCodeAt() && char < 'A'.charCodeAt()) || 
							(char > 'Z'.charCodeAt() && char < 'a'.charCodeAt()) || 
							(char > 'z'.charCodeAt()))) 
						{
							quote = true;
						}
						else if (char <= Constants.COMMENT)
						{
							quote = true;
						}
						else
						{
							while(pos < end)
							{
								char = value.charCodeAt(pos);
								if(char == Constants.LF || char == Constants.CR || char == quoteChar || char == delimChar)
								{
									quote = true;
									break;
								}
								pos++;
							}
							
							if(!quote)
							{
								pos = end - 1;
								char = value.charCodeAt(pos);
								if(char <= Constants.SP)
								{
									quote = true;
								}
							}
						}
					}
					
					if(!quote)
					{
						_writer.appendString(value, start, end);
						return;
					}
					break;
			}
			
			if(!quote)
			{
				_writer.appendString(value, start, end);
				return;
			}
			
			_writer.appendChar(quoteChar);
			
			while (pos < end)
			{
				char = value.charCodeAt(pos);
				if(char == quoteChar)
				{
					_writer.appendString(value, start, pos + 1);
					start = pos;
				}
				pos++;
			}
			
			_writer.appendString(value, start, pos);
			_writer.appendChar(quoteChar);
		}
		
		public function print(value:Object):void
		{
			var strValue:String;
			if(value == null)
			{ 
				var nullString:String = _format.getNullString();
				strValue = nullString == null ? Constants.EMPTY : nullString;
			}
			else
			{
				strValue = String(value);
			}
			this.printString(value, strValue, 0, strValue.length);
		}
		
		public function printRecords(values:Array):void
		{
			for(var i:int=0; i<values.length; i++)
			{
				printRecord(values[i]);
			}
		}
	}
}