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
	import flash.utils.IDataInput;

	public class CSVParser
	{
		protected var _lexer:CSVLexer;
		protected var _recordNumber:Number;
		protected var _format:CSVFormat;
		
		protected var _headerMap:Object;
		protected var _header:Array;
		
		protected var _record:Array;
		protected var _reusableToken:Token = new Token();
		
		public function CSVParser(input:IDataInput, format:CSVFormat=null)
		{
			if(format == null)
			{
				format = CSVFormat.buildDefault();
			}
			
			this._lexer = new CSVLexer(format, new BufferedUTF8Reader(input));
			this._format = format;
			initializeHeader();
		}
		
		public function getHeaderMap():Object
		{
			return _headerMap;
		}
		
		public function getHeader():Array
		{
			return _header;
		}
		
		public function getCurrentLineNumber():Number
		{
			return _lexer.getCurrentLineNumber();
		}
		
		public function getRecordNumber():Number
		{
			return _recordNumber;
		}
		
		internal function nextRecord():CSVRecord
		{
			var result:CSVRecord = null;
			_record = new Array();
			var sb:StringBuilder = null;
			
			do
			{
				_reusableToken.reset();
				_lexer.nextToken(_reusableToken);
				switch(_reusableToken.type)
				{
					case Token.TYPE_TOKEN:
						this.addRecordValue();
						break;
					case Token.TYPE_EORECORD:
						this.addRecordValue();
						break;
					case Token.TYPE_EOF:
						if(_reusableToken.isReady)
						{
							this.addRecordValue();
						}
						break;
					case Token.TYPE_INVALID:
						throw new Error("(line " + getCurrentLineNumber() + ") invalid parse sequence");
					case Token.TYPE_COMMENT:
						if(sb == null)
						{
							sb = new StringBuilder();
						}
						else
						{
							sb.appendChar(Constants.LF);
						}
						sb.appendStringBuilder(_reusableToken.content);
						_reusableToken.type = Token.TYPE_TOKEN;
						break;
				}
			}
			while (_reusableToken.type == Token.TYPE_TOKEN);
			
			if(_record.length != 0)
			{
				_recordNumber++;
				var comment:String = sb == null ? null : sb.toString();
				result = new CSVRecord(_record, _headerMap, comment, _recordNumber);
			}
			
			return result;
		}
		
		protected function addRecordValue():void
		{
			var input:String = _reusableToken.content.toString();
			var nullString:String = _format.getNullString();
			if(nullString == null)
			{
				_record.push(input);
			}
			else
			{
				_record.push(input.toLowerCase() == nullString ? null : input);
			}
		}
		
		public function getRecords():Array
		{
			var records:Array = new Array();
			var rec:CSVRecord;
			while ((rec = nextRecord()) != null)
			{
				records.push(rec);
			}
			return records;
		}
		
		protected function initializeHeader():Object
		{
			var hdrMap:Object = null;
			if(_format.getHeader() != null)
			{
				hdrMap = new Object();
				
				if(_format.getHeader().length == 0)
				{
					var record:CSVRecord = nextRecord();
					if(record != null)
					{
						_header = record.getValues();
					}
				}
				else
				{
					_header = _format.getHeader();
				}
				
				if(_header != null)
				{
					for(var i:int=0; i<_header.length;i++)
					{
						hdrMap[_header[i]] = Number(i);
					}
				}
			}
			return hdrMap;
		}
		

		protected var current:CSVRecord;
		
		public function hasNext():Boolean
		{
			if(current == null)
			{
				current = nextRecord();
			}
			
			return current != null;
		}

		public function next():CSVRecord
		{
			var next:CSVRecord = current;
			current = null;
			
			if(next == null)
			{
				next = nextRecord();
				if(next == null)
				{
					throw new Error("No more CSV records available");
				}
			}
			
			return next;
		}
	}
}