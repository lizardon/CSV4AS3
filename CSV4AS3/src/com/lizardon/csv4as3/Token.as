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
	public class Token
	{
		private static const INITIAL_TOKEN_LENGTH:int = 50;
		
		public static const TYPE_INVALID:String = "INVALID";
		public static const TYPE_TOKEN:String = "TOKEN";
		public static const TYPE_EOF:String = "EOF";
		public static const TYPE_EORECORD:String = "EORECORD";
		public static const TYPE_COMMENT:String = "COMMENT";
		
		internal var type:String = TYPE_INVALID;
		
		internal var content:StringBuilder = new StringBuilder();
		
		internal var isReady:Boolean;
		
		internal function reset():void
		{
			content.reset();
			type = TYPE_INVALID;
			isReady = false;
		}
		
		public function toString():String
		{
			return type + " [" + content.toString() + "]";
		}
	}
}