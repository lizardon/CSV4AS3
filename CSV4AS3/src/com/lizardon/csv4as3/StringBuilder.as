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
	public class StringBuilder
	{
		public var buffer:Array = new Array();
		
		public function appendString(str:String, start:int=0, end:int=0):StringBuilder
		{
			if(end < 1)
			{
				end = str.length;
			}
			
			for (var i:Number = start; i < end; i++)
			{
				buffer.push(str.charCodeAt(i));
			}
			
			return this;
		}
		
		public function appendStringBuilder(sb:StringBuilder):StringBuilder
		{
			buffer.push.apply(this, sb.buffer);
			return this;
		}
		
		public function appendChar(c:Number):StringBuilder
		{
			buffer.push(c);
			return this;
		}
		
		public function toString():String // off:Number, len:Number
		{
			return String.fromCharCode.apply(this, buffer);
		}
		
		public function reset():void
		{
			buffer.length = 0;
		}
		
		public function get length():Number
		{
			return buffer.length;
		}
		
		public function set length(value:Number):void
		{
			buffer.length = value;
		}
		
		public function trimTrailingSpaces():void
		{
			var len:Number = buffer.length;
			while(len > 0 && Constants.isWhiteSpace(buffer[len-1]))
			{
				len = len-1;
			}
			if(len != buffer.length())
			{
				buffer.length = len;
			}
		}
	}
}