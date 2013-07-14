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
	public class CSVRecord
	{
		protected static var EMPTY_STRING_ARRAY:Array = new Array();
		
		protected var _values:Array;
		protected var _mapping:Object;
		protected var _comment:String;
		protected var _recordNumber:Number;
		
		public function CSVRecord(values:Array, mapping:Object, comment:String, recordNumber:Number)
		{
			this._values = values;
			this._mapping = mapping;
			this._comment = comment;
			this._recordNumber = recordNumber;
		}
		
		public function getValueByIndex(columnIndex:int):String
		{
			return _values[columnIndex]
		}
		
		public function getValueByName(columnName:String):String
		{
			if(_mapping == null)
			{
				throw new Error(
					"No header mapping was specified, the record values can't be accessed by name");
			}
			
			var o:Object = _mapping[columnName];
			if(o == null || !(o is Number))
			{
				return null;
			}
			
			var index:Number = Number(o);
			if(index < 0 || index >= _values.length)
			{
				throw new Error("Index for header " + columnName + " is " + index + " but CSVRecord only has " + _values.length + " values!");
			}
			
			return _values[index];
		}
		
		public function isConsistent():Boolean
		{
			return _mapping == null ? true : Constants.getKeyCount(_mapping) == _values.length;
		}
		
		public function isMapped(columnName:String):Boolean
		{
			return _mapping != null ? _mapping[columnName] != null : false;
		}
		
		public function isSet(columnName:String):Boolean
		{
			if(_mapping == null) 
			{
				return false;
			}
			
			var o:Object = _mapping[columnName];
			if(o == null || !(o is Number))
			{
				return false;
			}
			
			var index:Number = Number(o);
			return (index >= 0 && index < _values.length);
		}
		
		internal function getValues():Array
		{
			return _values;
		}

		public function getComment():String
		{
			return _comment;
		}

		public function getRecordNumber():Number
		{
			return _recordNumber;
		}
		
		public function getSize():Number
		{
			return _values.length;
		}
		
		public function toString():String
		{
			if(_values == null) return null;
			
			var sb:StringBuilder = new StringBuilder();
			
			sb.appendString("[");
			for(var i:int=0; i<_values.length; i++)
			{
				if(i!=0)
				{
					sb.appendString(", ");
				}
				
				sb.appendString(_values[i]);
			}
			
			return sb.toString();
		}
	}
}