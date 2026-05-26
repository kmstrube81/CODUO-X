/* *************************************************************************************************
**** arrayPush(array arr, mixedtype element)
****
**** USAGE: adds element to end of array
****
**** returns updated array
****  
************************************************************************************************* */
arrayPush(arr, element)
{
	if(!isDefined(arr) || arr.size == 0 )
		arr = []; //define array if not defined
	arr[arr.size] = element;
	return arr;
}

/* *************************************************************************************************
**** arrayUnshift(array arr)
****
**** USAGE: adds element to begining of array
****
**** returns updated array
****  
************************************************************************************************* */
arrayUnshift(arr, element)
{
	if(!isDefined(arr))
		arr = []; //init new array if array not defined
	
	tempArr = [];
	
	tempArr[0] = element;
	
	for(i = 0; i < arr.size; i++) //loop through arr
		tempArr[i + 1] = arr[i];
	
	return tempArr; 
}

/* *************************************************************************************************
**** arrayPop(array arr)
****
**** USAGE: removes last element of array
****
**** returns updated array
****  
************************************************************************************************* */
arrayPop(arr)
{
	if(!isDefined(arr))
		return undefined; //return undefined if array not defined
	
	tempArr = [];
	
	if(arr.size <= 1)
		return tempArr;
	
	for(i = 0; i < arr.size - 1; i++) //loop through all but the last element
		tempArr[i] = arr[i];
	
	return tempArr; 
}

/* *************************************************************************************************
**** arrayShift(array arr)
****
**** USAGE: removes first element of array
****
**** returns updated array
****  
************************************************************************************************* */
arrayShift(arr)
{
	if(!isDefined(arr))
		return undefined; //return undefined if array not defined
	
	tempArr = [];
	
	if(arr.size <= 1)
		return tempArr;
	
	for(i = 0; i < arr.size - 1; i++) //loop through all but the first element
		tempArr[i] = arr[i + 1];
	
	return tempArr; 
}

/* *************************************************************************************************
**** arraySlice(array arr, int startIndex, int numToRemove (optional)
****
**** USAGE: removes the numToRemove number of items from array starting at startIndex
****
**** returns updated array
****  
************************************************************************************************* */ 
arraySlice(arr, startIndex, numToRemove)
{	//ensure numToRemove is valid
	if(!isDefined(numToRemove))
		numToRemove = 1;
	else if(numToRemove == 0)
		numToRemove = 1;
	
	//reduce number to remove by 1 (negative indicates leftward movement)
	if(numToRemove < 0)
		c = numToRemove + 1;
	else
		c = numToRemove - 1;
	//determine start and end indexes
	a = startIndex;
	b = startIndex + c;
	if(a < b)
	{
		start = a;
		end = b;
	}
	else if(a > b)
	{
		start = b;
		end = a;
	}
	tempArr = [];
	for(i = 0; i < arr.size; i++)
	{
		if(i >= start && i <= end)
			continue;
		tempArr = arrayPush(tempArr, arr[i]);
	}
	if(tempArr.size == 0)
		return undefined;
	return tempArr;
}

/* *************************************************************************************************
**** arrayFind(array arr, mixedtype searchVal)
****
**** USAGE: searches an array for searchVal
****
**** returns the index of the first instance of the search value
****  
************************************************************************************************* */
arrayFind(arr, searchVal)
{
	for(i = 0; i < arr.size; i++)
	{
		if( searchVal == arr[i])
			return i;
	}
	return undefined;
}

/* *************************************************************************************************
**** searchObjArrayByProperty(array arr, string property, mixedtype searchVal)
****
**** USAGE: searches an array of objects for a property value
****
**** returns the index of the first instance of the search value
****  
************************************************************************************************* */
searchObjArrayByProperty(arr, property, searchVal)
{
	for(i = 0; i < arr.size; i++)
	{
		obj = arr[i];
		if(searchVal == obj[property])
			return i;
	}
	return undefined;
}

/* *************************************************************************************************
**** updateObjArrayByProperty(array arr, string property, mixedtype searchVal)
****
**** USAGE: searches an array of objects for a property value and updates index
****
**** returns the updated array
****  
************************************************************************************************* */
updateObjArrayByProperty(arr, value, property, searchVal)
{
	index = searchObjArrayByProperty(arr, property, searchVal);
	
	if(isDefined(index))
		arr[index] = value;
	else
		arr = arrayPush(arr, value);
	return arr;
}