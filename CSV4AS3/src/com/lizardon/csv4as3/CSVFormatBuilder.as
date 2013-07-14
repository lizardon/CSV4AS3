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
	import com.lizardon.csv4as3.CSVFormat;
	
	import flash.errors.IllegalOperationError;

	public class CSVFormatBuilder
	{
		private var _delimiter:String;
		private var _quoteChar:String;
		private var _quotePolicy:Quote;
		private var _commentStart:String;
		private var _escape:String;
		private var _ignoreSurroundingSpaces:Boolean;
		private var _ignoreEmptyLines:Boolean;
		private var _recordSeparator:String;
		private var _nullString:String;
		private var _header:Array;
		
		public function CSVFormatBuilder(delimiter:String, quoteChar:String=null,
										 quotePolicy:Quote=null, commentStart:String=null,
										 esc:String=null, ignoreSurroundingSpaces:Boolean=false,
										 ignoreEmptyLines:Boolean=false, recordSeparator:String=null,
										 nullString:String=null, header:Array=null)
		{
			if(CSVFormat.isLineBreak(delimiter.charCodeAt()))
			{
				throw new Error("The delimiter cannot be a line break");
			}
			
			this._delimiter = delimiter;
			this._quoteChar = quoteChar;
			this._quotePolicy = quotePolicy;
			this._commentStart = commentStart;
			this._escape = esc;
			this._ignoreSurroundingSpaces = ignoreSurroundingSpaces;
			this._ignoreEmptyLines = ignoreEmptyLines;
			this._recordSeparator = recordSeparator;
			this._nullString = nullString;
			this._header = header;
		}
		
		public static function createWithCSVFormat(format:CSVFormat):CSVFormatBuilder
		{
			return new CSVFormatBuilder(format._delimiter, format._quoteChar, 
				format._quotePolicy, format._commentStart,
				format._escape, format._ignoreSurroundingSpaces,
				format._ignoreEmptyLines, format._recordSeparator,
				format._nullString, format._header);
		}
		
		public function build():CSVFormat
		{
			validate();
			return new CSVFormat(_delimiter, _quoteChar, 
				_quotePolicy, _commentStart, 
				_escape, _ignoreSurroundingSpaces, 
				_ignoreEmptyLines, _recordSeparator,
				_nullString, _header);
		}
		
		/**
		public function parse(reader:FileStreamWithLineReader):Iterable
		{
			return this.build().parse(reader);
		}
		**/
		
		private function validate():void
		{
			if(_quoteChar != null && _delimiter == _quoteChar)
			{
				throw new Error("The quoteChar character and the delimiter cannot be the same ('" + _quoteChar + "')");
			}
			
			if (_escape != null && _delimiter == _escape) {
				throw new Error(
					"The escape character and the delimiter cannot be the same ('" + _escape + "')");
			}
			
			if (_commentStart != null && _delimiter == _commentStart) {
				throw new Error(
					"The comment start character and the delimiter cannot be the same ('" + _commentStart + "')");
			}
			
			if (_quoteChar != null && _quoteChar == _commentStart) {
				throw new Error(
					"The comment start character and the quoteChar cannot be the same ('" + _commentStart + "')");
			}
			
			if (_escape != null && _escape == _commentStart) {
				throw new Error(
					"The comment start and the escape character cannot be the same ('" + _commentStart + "')");
			}
			
			if (_escape == null && _quotePolicy == Quote.NONE) {
				throw new Error("No quotes mode set but no escape character is set");
			}
		}
		
		public function withCommentStart(commentStart:String):CSVFormatBuilder 
		{
			if (CSVFormat.isLineBreak(commentStart.charCodeAt())) {
				throw new Error("The comment start character cannot be a line break");
			}
			this._commentStart = commentStart;
			return this;
		}
		
		public function withDelimiter(delimiter:String):CSVFormatBuilder 
		{
			if (CSVFormat.isLineBreak(delimiter.charCodeAt())) {
				throw new Error("The delimiter cannot be a line break");
			}
			this._delimiter = delimiter;
			return this;
		}
		
		public function withEscape(esc:String):CSVFormatBuilder {
			if (CSVFormat.isLineBreak(esc.charCodeAt())) {
				throw new Error("The escape character cannot be a line break");
			}
			this._escape = esc;
			return this;
		}
		
		public function withHeader(header:Array):CSVFormatBuilder {
			this._header = header;
			return this;
		}
		
		public function withIgnoreEmptyLines(ignoreEmptyLines:Boolean):CSVFormatBuilder {
			this._ignoreEmptyLines = ignoreEmptyLines;
			return this;
		}
		
		public function withIgnoreSurroundingSpaces(ignoreSurroundingSpaces:Boolean):CSVFormatBuilder {
			this._ignoreSurroundingSpaces = ignoreSurroundingSpaces;
			return this;
		}
		
		public function withNullString(nullString:String):CSVFormatBuilder {
			this._nullString = nullString;
			return this;
		}
		
		public function withQuoteChar(quoteChar:String):CSVFormatBuilder {
			if (CSVFormat.isLineBreak(quoteChar.charCodeAt())) {
				throw new Error("The quoteChar cannot be a line break");
			}
			this._quoteChar = quoteChar;
			return this;
		}
		
		public function withQuotePolicy(quotePolicy:Quote):CSVFormatBuilder {
			this._quotePolicy = quotePolicy;
			return this;
		}
		
		public function withRecordSeparator(recordSeparator:String):CSVFormatBuilder {
			this._recordSeparator = recordSeparator;
			return this;
		}
	}
}