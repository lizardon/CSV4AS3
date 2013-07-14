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
	public class Constants
	{
		public function Constants()
		{
		}
		
		public static const BACKSPACE:Number = '\b'.charCodeAt();
		public static const COMMA:Number = ','.charCodeAt();
		
		/**
		 * Starts a comment, the remainder of the line is the comment.
		 */
		public static const COMMENT:Number = '#'.charCodeAt();
		
		
		public static const CR:Number = '\r'.charCodeAt();
		public static const LF:Number = '\n'.charCodeAt();
		
		public static const DOUBLE_QUOTE:Number = "\"".charCodeAt();
		public static const BACKSLASH:Number = '\\'.charCodeAt();
		public static const FF:Number = '\f'.charCodeAt();
		public static const SP:Number = ' '.charCodeAt();
		public static const TAB:Number = '\t'.charCodeAt();
		public static const EMPTY:String = "";
		
		/** The end of stream symbol */
		public static const END_OF_STREAM:int = -1;
		
		/** Undefined state for the lookahead char */
		public static const UNDEFINED:int = -2;
		
		/** According to RFC 4180, line breaks are delimited by CRLF */
		public static const CRLF:String = "\r\n";
		
		/**
		 * Unicode line separator.
		 */
		public static const LINE_SEPARATOR:Number = 0x2028 // "\u2028";
		
		/**
		 * Unicode paragraph separator.
		 */
		public static const PARAGRAPH_SEPARATOR:Number = 0x2029 // "\u2029";
		
		/**
		 * Unicode next line.
		 */
		public static const NEXT_LINE:Number = 0x0085 // "\u0085";
		
		
		
		
		public static function isWhiteSpace(ch:String):Boolean {
			return ( ch == ' ' || ch == '\t' || ch == '\n' || ch == '\r');
		}
		
		public static function trim(str:String):String
		{
			return str.replace(/^\s+|\s+$/g, '');
		}
		
		public static function getKeyCount(d:Object):int
		{
			var count:int = 0;
			for (var key:Object in d)
			{
				count++;
			}
			return count;
		}
	}
}