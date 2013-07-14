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

	public class BufferedWriter
	{
		private var _buffer:Array = new Array();
		private var _bufferSize:Number;
		private var _output:IDataOutput;
		private var _charSet:String;
		
		public function BufferedWriter(output:IDataOutput, charSet="utf-8", bufferSize:Number=262144)
		{
			_output = output;
			_bufferSize = bufferSize;
			_charSet = charSet;
		}

		public function appendString(str:String, start:int=0, end:int=0):BufferedWriter
		{
			if(end < 1)
			{
				end = str.length;
			}
			
			for (var i:Number = start; i < end; i++)
			{
				_buffer.push(str.charCodeAt(i));
			}
			
			checkFlush();
			return this;
		}
		
		public function appendStringBuilder(sb:StringBuilder):BufferedWriter
		{
			_buffer.push.apply(this, sb.buffer);
			
			checkFlush();
			return this;
		}
		
		public function appendChar(c:Number):BufferedWriter
		{
			_buffer.push(c);
			
			checkFlush();
			return this;
		}
		
		protected function bufferToString():String
		{
			return String.fromCharCode.apply(this, _buffer);
		}
		
		protected function checkFlush():void
		{
			if(_buffer.length >= _bufferSize)
			{
				flush();
			}
		}
		
		public function flush():void
		{
			_output.writeMultiByte(bufferToString(), _charSet);
			
			_buffer.length = 0;
		}
	}
}