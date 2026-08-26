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

/* *************************************************************************************************
**** notifyLater(string msg, int delay, ent entity [optional])
****
**** sends a notify after the specified delay (in seconds)
****  
************************************************************************************************* */
notifyLater(msg, delay, ent)
{
    if(!isDefined(ent)) ent = level;

    ent endon("kill_later_" + msg);

	wait delay;
	ent notify(msg);
}

/* *************************************************************************************************
**** round(number num, int places)
****
**** rounds the specified number, the specified number of places. Negative numbers rounds decimal
**** places
****
************************************************************************************************** */
round(num, places)
{

    if(places == 0)
        return (string)num;

    number = (string)num;

    if(places < -10)
        places = - 10;

    split = stringSplit(number, ".");
    whole = split[0];
    decimal = split[1];

    wholeDigits = whole.size;
    if(isDefined(decimal))
        decimalDigits = decimal.size;
    else
    {
            decimalDigits = 0;
            decimal = [];
    }

    if(decimalDigits < -10)
        decimalDigits = -10;

    rounded = "";

    if(places > 0) //leftward whole number rounding
    {
        wholes = [];
        place = wholeDigits - places;
        roundUp = false;
        for(index = wholeDigits - 1; index >= 0; index--)
        {
           
            if(index > place) 
                wholes[wholes.size] = 0;
            else if(index == place)
            {
                if(places == 1)
                {
                    if(decimalDigits == 0)
                        return (string)num;
                    else
                        factor = (int)decimal[0];
                }
                else
                    factor = (int)whole[index + 1];
                if(factor >= 5)
                    n = (int)(whole[index]) + 1;
                else
                    n = (int)(whole[index]);
                
                if(n > 9)
                {
                    n = 0;
                    roundUp = true;
                }
                wholes[wholes.size] = n;
            }
            else
            {
                if(roundUp)
                {
                    n = (int)(whole[index]) + 1;
                    if(n > 9)
                    {
                        n = 0;
                        roundUp = true;
                    }
                    else
                        roundUp = false;
                }
                else
                    n = whole[index];
                
                wholes[wholes.size] = n; 
            }
        }
        //walk whole numbers in reverse and add to rounded string
        for(i = wholes.size - 1; i <= 0; i--)
            rounded += (string)wholes[i];
    }
    else if(places < 0) //move rightward for decimals
    {
        decimals = []; //keep chars in an array in case of multiple 9s
        place = places * -1;
        for(index = 0; index < place; index++)
        {
            if(index + 1 < place)
                decimals[decimals.size] = (int)decimal[charIndex];
            else if(index + 1 == place)
            {
                if(!isDefined(decimal[index + 1]))
                    factor = 0;
                else
                    factor = (int)decimal[index + 1];
                if(factor >= 5)
                    n = (int)(decimal[index]) + 1;
                else
                    n = (int)(decimal[index]);
                
                decimals[decimals.size] = n;
            }
        }
        roundUp = false;
        //walk decimals and resolve any rounding
        for(index = decimals.size - 1; index >= 0; index--)
        {
            if(roundUp)
            {
                n = decimals[index] + 1;
                roundUp = false;
            }
            else
                n = decimals[index];
            if(n > 9)
            {
                n = 0;
                roundUp = true;
            }
            decimals[index] = (string)n;
        }
        //if roundUp is still marked, then add 1 to the whole number
        if(roundUp)
            whole = (int)whole + 1;
        rounded += (string)whole;
        rounded += ".";
        //walk decimals one last time adding to the string
        for(i = 0; i < decimals.size; i++)
            rounded += decimals[i];
    }
    return rounded;
}

