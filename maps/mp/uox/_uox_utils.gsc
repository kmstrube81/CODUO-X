/* *************************************************************************************************
**** stringSplit(string str, string seperator)
****
**** USAGE: splits a string into an array of substrings split on seperator
****
**** returns substring array
****  
************************************************************************************************* */
stringSplit(str, seperator)
{
	if(seperator.size > 1)
		seperator = seperator[0];
		
	substringArrayIndex = 0; //index of substring char
	substrings[substringArrayIndex] = ""; //init sub string as a blank char;
	
	for(charIndex = 0; charIndex < str.size; charIndex++)
	{
		if(str[charIndex] == seperator) //if the current char is the seperator char
		{
			substringArrayIndex++;
			substrings[substringArrayIndex] = ""; //init next index in substring array
		}
		else
		{
			substrings[substringArrayIndex] += str[charIndex];
		}
	}
	return substrings;
}