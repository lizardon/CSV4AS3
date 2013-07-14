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
	public class CSVLexer
	{
		public static const DISABLED:String = '\ufffe';
		
		private var _delimiter:String;
		private var _escape:String;
		private var _quoteChar:String;
		private var _commmentStart:String;
		
		internal var _ignoreSurroundingSpaces:Boolean;
		internal var _ignoreEmptyLines:Boolean;
		
		internal var _format:CSVFormat;
		
		internal var _reader:BufferedUTF8Reader;
		
		public function CSVLexer(format:CSVFormat, reader:BufferedUTF8Reader)
		{
			this._format = format;
			this._reader = reader;
			
			this._delimiter = format.getDelimiter();
			this._escape = mapNullToDisabled(format.getEscape());
			this._quoteChar = mapNullToDisabled(format.getQuoteChar());
			this._commmentStart = mapNullToDisabled(format.getCommentStart());
			this._ignoreSurroundingSpaces = format.getIgnoreSurroundingSpaces();
			this._ignoreEmptyLines = format.getIgnoreEmptyLines();
		}
		
		private static function mapNullToDisabled(c:String):String
		{
			return c == null ? DISABLED : c;
		}
		
		internal function getCurrentLineNumber():Number {
			return _reader.currentLineNumber;
		}
		
		internal function readEscape():Number
		{
			var char:Number = _reader.readChar();
			
			switch(char)
			{
				case 'r'.charCodeAt():
					return Constants.CR;
				
				case 'n'.charCodeAt():
					return Constants.LF;
				
				case 't'.charCodeAt():
					return Constants.TAB;
				
				case 'b'.charCodeAt():
					return Constants.BACKSPACE;
				
				case 'f'.charCodeAt():
					return Constants.FF;
				
				case Constants.CR:
				
				case Constants.LF:
				
				case Constants.FF:
				
				case Constants.TAB:
				
				case Constants.BACKSPACE:
					return char;
				
				case Constants.END_OF_STREAM:
					throw new Error("EOF whilst processing escape sequence");
				
				default:
					if(isMetaChar(char))
					{
						return char;
					}
					else
					{
						return Constants.END_OF_STREAM;
					}
			}
			return -1;	
		}
		
		internal function readEndOfLine(char:Number):Boolean
		{
			if(char == Constants.CR && _reader.lookAhead() == Constants.LF)
			{
				char = _reader.readChar();
			}
			
			return char == Constants.LF || char == Constants.CR;
		}
		
		internal function isWhitespace(char:Number):Boolean
		{
			return !isDelimiter(char) && Constants.isWhiteSpace(String.fromCharCode(char));
		}
		
		internal function isStartOfLine(char:Number):Boolean
		{
			return char == Constants.LF || char == Constants.CR || char == Constants.UNDEFINED;
		}
		
		internal function isEndOfFile(char:Number):Boolean
		{
			return char == Constants.END_OF_STREAM;
		}
		
		internal function isDelimiter(char:Number):Boolean
		{
			return String.fromCharCode(char) == _delimiter;
		}
		
		internal function isEscape(char:Number):Boolean
		{
			return String.fromCharCode(char) == _escape;
		}
		
		internal function isQuoteChar(char:Number):Boolean
		{
			return String.fromCharCode(char) == _quoteChar;
		}
		
		internal function isCommentStart(char:Number):Boolean
		{
			return String.fromCharCode(char) == _commmentStart;
		}
		
		internal function isMetaChar(char:Number):Boolean {
			var s:String = String.fromCharCode(char);
			return s == _delimiter ||
				s == _escape ||
				s == _quoteChar ||
				s == _commmentStart;
		}
		
		internal function nextToken(token:Token):Token
		{
			var lastChar:Number = _reader.lastChar;
			var char:Number = _reader.readChar();
			var eol:Boolean = readEndOfLine(char);
			
			if(_ignoreEmptyLines)
			{
				while (eol && isStartOfLine(lastChar))
				{
					lastChar = char;
					char = _reader.readChar();
					eol = readEndOfLine(char);
					
					if(isEndOfFile(char))
					{
						token.type = Token.TYPE_EOF;
						return token;
					}
				}
			}
			
			if(isEndOfFile(lastChar) || (!isDelimiter(lastChar) && isEndOfFile(char)))
			{
				token.type = Token.TYPE_EOF;
				return token;
			}
			
			if(isStartOfLine(lastChar) && isCommentStart(char))
			{
				var line:String = _reader.readLine();
				if(line == null)
				{
					token.type = Token.TYPE_EOF;
					return token;
				}
				var comment:String = Constants.trim(line);
				token.content.appendString(comment);
				token.type = Token.TYPE_COMMENT;
				return token;
			}
			
			while(token.type == Token.TYPE_INVALID)
			{
				if(_ignoreSurroundingSpaces)
				{
					while(isWhitespace(char) && !eol)
					{
						char = _reader.readChar();
						eol = readEndOfLine(char);
					}
				}
				
				if(isDelimiter(char))
				{
					token.type = Token.TYPE_TOKEN;
				}
				else if (eol)
				{
					token.type = Token.TYPE_EORECORD	
				}
				else if (isQuoteChar(char))
				{
					parseEncapsulatedToken(token);
				}
				else if (isEndOfFile(char))
				{
					token.type = Token.TYPE_EOF;
					token.isReady = true;
				}
				else
				{
					parseSimpleToken(token, char);	
				}
			}
			
			return token;	
		}
		
		protected function parseSimpleToken(token:Token, char:Number):Token
		{
			while(true)
			{
				if(readEndOfLine(char))
				{
					token.type = Token.TYPE_EORECORD;
					break;
				}
				else if (isEndOfFile(char))
				{
					token.type = Token.TYPE_EOF;
					token.isReady = true;
					break;
				}
				else if (isDelimiter(char))
				{
					token.type = Token.TYPE_TOKEN;
					break
				}
				else if (isEscape(char))
				{
					var unescaped:Number = readEscape();
					if(unescaped == Constants.END_OF_STREAM)
					{
						token.content.appendChar(char).appendChar(_reader.lastChar);
					}
					else
					{
						token.content.appendChar(unescaped);
					}
					char = _reader.readChar();
				}
				else
				{
					token.content.appendChar(char);
					char = _reader.readChar();
				}
			}
			
			if(_ignoreSurroundingSpaces)
			{
				token.content.trimTrailingSpaces();
			}
			
			return token;
		}
		
		protected function parseEncapsulatedToken(token:Token):Token
		{
			var startLineNumber:Number = getCurrentLineNumber();
			var char:Number;
			
			while(true)
			{
				char = _reader.readChar();
				
				if(isEscape(char))
				{
					var unescaped:Number = readEscape();
					if(unescaped == Constants.END_OF_STREAM)
					{
						token.content.appendChar(char).appendChar(_reader.lastChar);
					}
					else
					{
						token.content.appendChar(unescaped);
					}
				}
				else if (isQuoteChar(char))
				{
					if(isQuoteChar(_reader.lookAhead()))
					{
						char = _reader.readChar();
						token.content.appendChar(char);
					}
					else
					{
						while(true)
						{
							char = _reader.readChar();
							if(isDelimiter(char))
							{
								token.type = Token.TYPE_TOKEN;
								return token;
							}
							else if (isEndOfFile(char))
							{
								token.type = Token.TYPE_EOF;
								token.isReady = true;
								return token;
							}
							else if (readEndOfLine(char))
							{
								token.type = Token.TYPE_EORECORD;
								return token;
							}
							else if (!isWhitespace(char))
							{
								throw new Error("(line " + getCurrentLineNumber() +
									") invalid char between encapsulated token and delimiter");
							}
						}
					}
				}
				else if (isEndOfFile(char))
				{
					// error condition (end of file before end of token)
					throw new Error("(startline " + startLineNumber +
						") EOF reached before encapsulated token finished");
				}
				else
				{
					token.content.appendChar(char);
				}
			}
			
			// this line should not be reached
			return token;
		}
	}
}