/* *************************************************************************************************
**** stringSplit(string str, string seperator)
****
**** USAGE: splits a string into an array of substrings split on seperator
****
**** returns substring array
****  
************************************************************************************************* */
stringSplit(str, sep, skipEmpty, quote, trimWhiteSpace)
{
    if ( !isdefined( str ) || ( str == "" ) )
		return ( [] );

	if ( !isdefined( sep ) || ( sep == "" ) )
		sep = ";";	// Default separator

	if ( !isdefined( quote ) )
		quote = "";

    if ( !isdefined( trimWhiteSpace ) )
        trimWhiteSpace = true;

	skipEmpty = isdefined( skipEmpty );

	a = _splitRecur( 0, str, sep, quote, skipEmpty );


    if(trimWhiteSpace)
        a = trimArray(a);

	return ( a );
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

findStr( find, str, pos )
{
	if ( !isdefined( find ) || ( find == "" ) || 
		 !isdefined( str ) || 
		 !isdefined( pos ) || 
		 ( find.size > str.size ) )
		return ( -1 );

	fsize = find.size;
	ssize = str.size;

	switch ( pos )
	{
	  case "start": place = 0 ; break;
	  case "end":	place = ssize - fsize; break;
	  default:	place = 0 ; break;
	}

	for ( i = place; i < ssize; i++ )
	{
		if ( i + fsize > ssize )
			break;			// Too late to compare

		// Compare now ...
		for ( j = 0; j < fsize; j++ )
			if ( str[ i + j ] != find[ j ] )
				break;		// No match

		if ( j >= fsize )
			return ( i );		// Found it!

		if ( pos == "start" )
			break;			// Didn't find at start
	}

	return ( -1 );
}

_splitRecur( iter, str, sep, quote, skipEmpty )
{
	s = sep[ iter ];

	_a = [];
	_s = "";
	doQuote = false;
	for ( i = 0; i < str.size; i++ )
	{
		ch = str[ i ];
		if ( ch == quote )
		{
			doQuote = !doQuote;

			if ( iter + 1 < sep.size )
				_s += ch;
		}
		else
		if ( ( ch == s ) && !doQuote )
		{
			if ( ( _s != "" ) || !skipEmpty )
			{
				_l = _a.size;

				if ( iter + 1 < sep.size )
				{
					_x = _splitRecur( iter + 1, _s,	sep, quote, skipEmpty );

					if ( ( _x.size > 0 ) || !skipEmpty )
					{
						_a[ _l ][ "str" ] = _s;
						_a[ _l ][ "fields" ] = _x;
					}
				}
				else
					_a[ _l ] = _s;
			}

			_s = "";
		}
		else
			_s += ch;
	}

	if ( _s != "" )
	{
		_l = _a.size;

		if ( iter + 1 < sep.size )
		{
			_x = _splitRecur( iter + 1, _s, sep, quote, skipEmpty );
			if ( _x.size > 0 )
			{
				_a[ _l ][ "str" ] = _s;
				_a[ _l ][ "fields" ] = _x;
			}
		}
		else
			_a[ _l ] = _s;
	}

	return ( _a );
}

/* *************************************************************************************************
**** trim(string str, string chars [optional])
****
**** USAGE: removes leading and trailing characters found in chars from str
****        chars defaults to " " (space). Pass e.g. " ," to also strip commas.
****
**** returns trimmed string ("" if str is undefined or entirely trimmed)
****  
************************************************************************************************* */
trim( str, chars )
{
	if ( !isdefined( str ) || ( str == "" ) )
		return ( "" );

	if ( !isdefined( chars ) || ( chars == "" ) )
		chars = " ";

	// find first character not in chars
	start = 0;
	while ( ( start < str.size ) && _isTrimChar( str[ start ], chars ) )
		start++;

	// find last character not in chars
	end = str.size - 1;
	while ( ( end >= start ) && _isTrimChar( str[ end ], chars ) )
		end--;

	// rebuild the kept range
	_s = "";
	for ( i = start; i <= end; i++ )
		_s += str[ i ];

	return ( _s );
}

/* *************************************************************************************************
**** trimArray(array arr, string chars [optional])
****
**** USAGE: trims every string element of arr (e.g. the result of stringSplit)
****
**** returns new array of trimmed strings
****  
************************************************************************************************* */
trimArray( arr, chars )
{
	_a = [];
	if ( !isdefined( arr ) )
		return ( _a );

	for ( i = 0; i < arr.size; i++ )
		_a[ i ] = trim( arr[ i ], chars );

	return ( _a );
}

_isTrimChar( ch, chars )
{
	for ( j = 0; j < chars.size; j++ )
		if ( ch == chars[ j ] )
			return ( true );

	return ( false );
}

/* *************************************************************************************************
**** subStr(string str, int start, int len [optional])
****
**** USAGE: returns the rest of the given string, starting at start, for optional length
**** (leave undefined to return rest of string)
****
**** returns new string
****  
************************************************************************************************* */
subStr( str, start, len )
{
	if ( !isdefined( str ) || ( str == "" ) )
		return ( "" );

	if ( !isdefined( start ) || ( start < 0 ) )
		start = 0;

	if ( start >= str.size )
		return ( "" );

	// Optional length: if omitted, run to end of string
	end = str.size;
	if ( isdefined( len ) && ( start + len < end ) )
		end = start + len;

	out = "";
	for ( i = start; i < end; i++ )
		out += str[ i ];

	return ( out );
}
