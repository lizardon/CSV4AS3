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
	public class CSVFormat
	{
		public static function newBuilder():CSVFormatBuilder
		{
			return new CSVFormatBuilder(String.fromCharCode(Constants.COMMA), String.fromCharCode(Constants.DOUBLE_QUOTE), null, null, null, false, true, Constants.CRLF, null, null);
		}
		
		public static function newBuilderWithDelimiter(delimiter:String):CSVFormatBuilder
		{
			return new CSVFormatBuilder(delimiter);
		}
		
		public static function newBuilderWithFormat(format:CSVFormat):CSVFormatBuilder
		{
			return CSVFormatBuilder.createWithCSVFormat(format);
		}
		
		public static function buildRFC4180():CSVFormat
		{
			return newBuilder()
				.withIgnoreEmptyLines(false)
				.build();
		}
		
		public static function buildDefault():CSVFormat
		{
			return newBuilder()
				.build();
		}
		
		public static function buildDefaultWithHeader(header:Array=null):CSVFormat
		{
			return newBuilder()
				.withHeader(header == null ? [] : header)
				.build();
		}
		
		public static function buildExcel():CSVFormat
		{
			return newBuilder()
				.withIgnoreEmptyLines(false)
				.build();
		}
		
		public static function buildTDF():CSVFormat
		{
			return newBuilder()
				.withDelimiter(String.fromCharCode(Constants.TAB))
				.withIgnoreSurroundingSpaces(true)
				.build();
		}
			
		public static function buildMYSQL():CSVFormat
		{
			return newBuilder()
				.withDelimiter(String.fromCharCode(Constants.TAB))
				.withQuoteChar(null)
				.withEscape(String.fromCharCode(Constants.BACKSLASH))
				.withIgnoreEmptyLines(false)
				.withRecordSeparator(String.fromCharCode(Constants.LF))
				.build();
		}
		
		public static function isLineBreak(c:Number):Boolean
		{
			return  c == Constants.LF || c == Constants.CR;
		}
		
		public static function areEqual(a:Array,b:Array):Boolean 
		{
			if(a.length != b.length) {
				return false;
			}
			var len:int = a.length;
			for(var i:int = 0; i < len; i++) {
				if(a[i] !== b[i]) {
					return false;
				}
			}
			return true;
		}
		
		public function CSVFormat(delimiter:String, quoteChar:String,
								  quotePolicy:Quote, commentStart:String,
								  esc:String, ignoreSurroundingSpaces:Boolean,
								  ignoreEmptyLines:Boolean, recordSeparator:String,
								  nullString:String, header:Array)
		{
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
		
		internal var _delimiter:String;
		internal var _quoteChar:String;
		internal var _quotePolicy:Quote;
		internal var _commentStart:String;
		internal var _escape:String;
		internal var _ignoreSurroundingSpaces:Boolean;
		internal var _ignoreEmptyLines:Boolean;
		internal var _recordSeparator:String;
		internal var _nullString:String;
		internal var _header:Array;
		
		/**
				public Iterable<CSVRecord> parse(final Reader in) throws IOException {
					return new CSVParser(in, this);
				}
				
				public String format(final Object... values) {
					final StringWriter out = new StringWriter();
					try {
						new CSVPrinter(out, this).printRecord(values);
						return out.toString().trim();
					} catch (final IOException e) {
						// should not happen because a StringWriter does not do IO.
						throw new IllegalStateException(e);
					}
				}
		**/
		
		/**
			 	public int hashCode()
				 {
				 final int prime = 31;
				 int result = 1;
				 
				 result = prime * result + delimiter;
				 result = prime * result + ((quotePolicy == null) ? 0 : quotePolicy.hashCode());
				 result = prime * result + ((quoteChar == null) ? 0 : quoteChar.hashCode());
				 result = prime * result + ((commentStart == null) ? 0 : commentStart.hashCode());
				 result = prime * result + ((escape == null) ? 0 : escape.hashCode());
				 result = prime * result + (ignoreSurroundingSpaces ? 1231 : 1237);
				 result = prime * result + (ignoreEmptyLines ? 1231 : 1237);
				 result = prime * result + ((recordSeparator == null) ? 0 : recordSeparator.hashCode());
				 result = prime * result + Arrays.hashCode(header);
				 return result;
				 }
		 */
		
		public function equals(obj:Object):Boolean
		{
			if (this == obj) {
				return true;
			}
			
			if (obj == null) {
				return false;
			}
			
			if (!(obj is CSVFormat)) {
				return false;
			}
			
			var other:CSVFormat = CSVFormat(obj);
			
			if (_delimiter != other._delimiter) 
			{
				return false;
			}
			
			if (_quotePolicy != other._quotePolicy) 
			{
				return false;
			}
			
			if (_quoteChar == null) {
				if (other._quoteChar != null) 
				{
					return false;
				}
			} 
			else if (!_quoteChar == other._quoteChar) 
			{
				return false;
			}
			
			if (_commentStart == null) 
			{
				if (other._commentStart != null) 
				{
					return false;
				}
			} 
			else if (!_commentStart == other._commentStart) 
			{
				return false;
			}
			
			if (_escape == null) 
			{
				if (other._escape != null) 
				{
					return false;
				}
			} 
			else if (_escape != other._escape) 
			{
				return false;
			}
			
			if (!areEqual(_header, other._header)) 
			{
				return false;
			}
			
			if (_ignoreSurroundingSpaces != other._ignoreSurroundingSpaces) 
			{
				return false;
			}
			
			if (_ignoreEmptyLines != other._ignoreEmptyLines) 
			{
				return false;
			}
			
			if (_recordSeparator == null) 
			{
				if (other._recordSeparator != null) 
				{
					return false;
				}
			} 
			else if (!_recordSeparator == other._recordSeparator) 
			{
				return false;
			}
			
			return true;
		}
		
		public function getCommentStart():String 
		{
			return _commentStart;
		}
		
		public function getDelimiter():String 
		{
			return _delimiter;
		}
		
		public function getEscape():String 
		{
			return _escape;
		}
		
		internal function getHeader():Array
		{
			return _header;
		}
		
		public function getIgnoreEmptyLines():Boolean
		{
			return _ignoreEmptyLines;
		}
		
		public function getIgnoreSurroundingSpaces():Boolean 
		{
			return _ignoreSurroundingSpaces;
		}
		
		public function getNullString():String 
		{
			return _nullString;
		}
		
		public function getQuoteChar():String 
		{
			return _quoteChar;
		}
		
		public function getQuotePolicy():Quote 
		{
			return _quotePolicy;
		}
		
		public function getRecordSeparator():String 
		{
			return _recordSeparator;
		}
		
		public function isCommentingEnabled():Boolean 
		{
			return _commentStart != null;
		}
		
		public function isEscaping():Boolean 
		{
			return _escape != null;
		}
		
		public function isQuoting():Boolean 
		{
			return _quoteChar != null;
		}
		
		public function toBuilder():CSVFormatBuilder
		{
			return CSVFormatBuilder.createWithCSVFormat(this);
		}
		
		public function toString():String {
			var sb:StringBuilder = new StringBuilder();
			sb.appendString("Delimiter=<").appendString(_delimiter).appendString('>');
			if (isEscaping()) {
				sb.appendString(' ');
				sb.appendString("Escape=<").appendString(_escape).appendString('>');
			}
			if (isQuoting()) {
				sb.appendString(' ');
				sb.appendString("QuoteChar=<").appendString(_quoteChar).appendString('>');
			}
			if (isCommentingEnabled()) {
				sb.appendString(' ');
				sb.appendString("CommentStart=<").appendString(_commentStart).appendString('>');
			}
			if (getIgnoreEmptyLines()) {
				sb.appendString(" EmptyLines:ignored");
			}
			if (getIgnoreSurroundingSpaces()) {
				sb.appendString(" SurroundingSpaces:ignored");
			}
			return sb.toString();
		}
	}
}