/* *************************************************************************************************
**** arrayPush(array arr, mixedtype element)
****
**** USAGE: adds element to end of array. SUPER ARRAY USAGE: Adds element to end of array with synthetic
**** key if none specified, otherwise updates key if it exists or adds it to the end of the super array
****
**** SUPER ARRAY: If no key is specified, a synthetic numeric key equal to the
**** current length is used (0, 1, 2...). If callers mix synthetic and explicit
**** keys in the same super array, collisions are possible — e.g. pushing with
**** no key after the array has explicit key "3" present will collide if length
**** also happens to be 3. Either use explicit keys throughout, or rely on
**** synthetic keys throughout; do not mix in arrays where collision matters.
**** 
**** returns updated array
****  
************************************************************************************************* */
arrayPush(arr, element, key)
{
	if(!isDefined(arr))
		arr = []; //define array if not defined
	
	if(isSuperArray(arr))
	{
		i = arr["length"];
		if(!isDefined(key)) //add synthetic key if not defined
			key = i;
		if(!isDefined(arr["values"][key]))
		{
			arr["keys"][i] = key;
			arr["length"] = i + 1;
		}
		arr["values"][key] = element;
		return arr;
	}
	
	arr[arr.size] = element;
	return arr;
}

/* *************************************************************************************************
**** arrayUnshift(array arr)
****
**** USAGE: adds element to begining of array, SUPER ARRAY USAGE: if no key specified adds element to
**** superArray with key of 0, otherwise adds key to begining of superarray with the specified element
**** or updates existing key in array if it already exists
****
**** returns updated array
****  
************************************************************************************************* */
arrayUnshift(arr, element, key)
{
	if(!isDefined(arr))
		arr = []; //init new array if array not defined
	
	if(isSuperArray(arr))
	{
		tempArr = [];
		shift = false;
		if(!isDefined(key))
		{
			key = 0;
			shift = true;
		}
		if(isDefined(arr["values"][key]))
		{
			if(shift)
			{
				tempArr["keys"][0] = 0; //add synthetic key
				tempArr["values"][0] = element;
				for(i = 0; i < arr["length"]; i++) //add rest of values
				{
					tempArr["keys"][i + 1] = arr["keys"][i];
					tempArr["values"][arr["keys"][i]] = arr["values"][arr["keys"][i]];
				}
				return tempArr;
			}
			arr["values"][key] = element;
			return arr;
		}
		
		tempArr["keys"][0] = key;
		tempArr["values"][key] = element;
		for(i = 0; i < arr["length"]; i++) //add rest of values
		{
			tempArr["keys"][i + 1] = arr["keys"][i];
			tempArr["values"][arr["keys"][i]] = arr["values"][arr["keys"][i]];
		}
		tempArr["length"] = arr["length"] + 1;
		return tempArr;
	}
	
	tempArr = [];
	
	tempArr[0] = element;
	
	for(i = 0; i < arr.size; i++) //loop through arr
		tempArr[i + 1] = arr[i];
	
	return tempArr; 
}

/* *************************************************************************************************
**** arrayPop(array arr)
****
**** USAGE: removes last element of array. SUPER ARRAY USAGE: if no key specified removes most recent 
**** key added to super array, otherwise removes specified key
****
**** returns updated array
****  
************************************************************************************************* */
arrayPop(arr, key)
{
	if(!isDefined(arr))
		return undefined; //return undefined if array not defined
	
	if(isSuperArray(arr))
	{
		tempArr = [];
		
		if(!isDefined(key))
		{
			if(arr["length"] <= 1)
			return tempArr;
		
			for(i = 0; i < arr["length"] - 1; i++)
			{
				tempArr["keys"][tempArr["keys"].size] = arr["keys"][i];
				tempArr["values"][arr["keys"][i]] = arr["values"][arr["keys"][i]];
			}
            tempArr["length"] = arr["length"] - 1;
			return tempArr;
		}
		if(!isDefined(arr["values"][key]))
			return arr;
        j = 0;
		for(i = 0; i < arr["length"]; i++)
		{
			if(arr["keys"][i] == key)
				continue;
			tempArr["keys"][j] = arr["keys"][i];
			tempArr["values"][arr["keys"][i]] = arr["values"][arr["keys"][i]];
            j++;
		}
        tempArr["length"] = arr["length"] - 1;
		return tempArr;		
	}
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
**** USAGE: removes first element of array. SUPER ARRAY USAGE: if no key specified removes most recent 
**** key added to super array, otherwise removes specified key
****
**** returns updated array
****  
************************************************************************************************* */
arrayShift(arr, key)
{
	if(!isDefined(arr))
		return undefined; //return undefined if array not defined
	
	if(isSuperArray(arr))
	{
		tempArr = [];
		
		if(!isDefined(key))
		{
			if(arr["length"] <= 1)
				return tempArr;
			
			for(i = 1; i < arr["length"]; i++)
			{
				tempArr["keys"][tempArr["keys"].size] = arr["keys"][i];
				tempArr["values"][arr["keys"][i]] = arr["values"][arr["keys"][i]];
			}
            tempArr["length"] = arr["length"] - 1;
			return tempArr;
		}
		if(!isDefined(arr["values"][key]))
			return arr;
        j = 0;
		for(i = 0; i < arr["length"] - 1; i++)
		{
			if(arr["keys"][i] == key)
				continue;
			tempArr["keys"][j] = arr["keys"][i];
			tempArr["values"][arr["keys"][i]] = arr["values"][arr["keys"][i]];
            j++;
		}
        tempArr["length"] = arr["length"] - 1;
		return tempArr;
	}
	
	tempArr = [];
	
	if(arr.size <= 1)
		return tempArr;
	
	for(i = 0; i < arr.size - 1; i++) //loop through all but the first element
		tempArr[i] = arr[i + 1];
	
	return tempArr; 
}

/* *************************************************************************************************
**** arraySlice(array arr, int startIndex, int numToRemove (optional), arr keys (optional))
****
**** USAGE: removes the numToRemove number of items from array starting at startIndex
**** SUPER ARRAY USAGE: removes all keys if specified, otherwise removes the specified number of
**** keys after the startIndex
****
**** returns updated array
****  
************************************************************************************************* */ 
arraySlice(arr, startIndex, numToRemove, keys)
{	//ensure numToRemove is valid
	if(!isDefined(numToRemove))
		numToRemove = 1;
	else if(numToRemove == 0)
		numToRemove = 1;
	
	if(isSuperArray(arr))
	{
		tempArr = superArray();
		if(isDefined(keys))
		{
			for(i = 0; i < arr["length"]; i++)
			{
				skip = false;
				for(j = 0; j < keys.size; j++)
				{
					if(arr["keys"][i] == keys[j])
						skip = true;
				}
				if(skip)
					continue;
				tempArr["keys"][tempArr["keys"].size] = arr["keys"][i];
				tempArr["values"][arr["keys"][i]] = arr["values"][arr["keys"][i]];
			}
			return tempArr;
		}
		if(numToRemove > 0) abs = numToRemove; else abs = numToRemove * -1;
		cnt = 0;
		keys = [];
		for(i = 0; i < arr["length"]; i++)
		{
			if(arr["keys"][i] == startIndex)
			{
				keys[cnt] = arr["keys"][i];
				cnt = 1;
				break;
			}
		}
		if(numToRemove > 0) key = i + cnt; else key = i - cnt;
		while(cnt < abs && key > -1 && key < arr["length"])
		{
			
			if(isDefined(arr["keys"][key]))
				keys[keys.size] = arr["keys"][key];
			cnt++;
			if(numToRemove > 0) key = i + cnt; else key = i - cnt;
		}
		for(i = 0; i < arr["length"]; i++)
		{
			skip = false;
			for(j = 0; j < keys.size; j++)
			{
				if(arr["keys"][i] == keys[j])
					skip = true;
			}
			if(skip)
				continue;
			tempArr["keys"][tempArr["keys"].size] = arr["keys"][i];
			tempArr["values"][arr["keys"][i]] = arr["values"][arr["keys"][i]];
		}
		return tempArr;
	}

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
	
	return tempArr;
}

/* *************************************************************************************************
**** arrayFind(array arr, mixedtype searchVal, bool oneOrAll (optional) )
****
**** USAGE: searches an array for searchVal.
****
**** returns the index of the first instance of the search value if oneOrAll is false or undefined
**** or an array of indices/keys if its true
****  
************************************************************************************************* */
arrayFind(arr, searchVal, oneOrAll)
{
	if(!isDefined(oneOrAll))
		oneOrAll = false;
	
	if(isSuperArray(arr))
	{
		tempArr = [];
	
		for(i = 0; i < arr["length"]; i++)
		{
			if( searchVal == arr["values"][arr["keys"][i]])
			{
				tempArr[tempArr.size] = arr["keys"][i];
				if(!oneOrAll)
					return arr["keys"][i];
			}
		}
		if(tempArr.size > 0)
			return tempArr;
		return undefined;
	}
	tempArr = [];
	
	for(i = 0; i < arr.size; i++)
	{
		if( searchVal == arr[i])
		{
			tempArr[tempArr.size] = i;
			if(!oneOrAll)
				return i;
		}
	}
	if(tempArr.size > 0)
		return tempArr;
	return undefined;
}

/* *************************************************************************************************
**** searchObjArrayByProperty(array arr, string property, mixedtype searchVal)
****
**** USAGE: searches an array of objects for a property value
****
**** returns the index of the first instance of the search value if oneOrAll is undefined or false
**** or an array of indices/keys if it is true
****  
************************************************************************************************* */
searchObjArrayByProperty(arr, property, searchVal, oneOrAll)
{
	if(!isDefined(oneOrAll))
		oneOrAll = false;
	
	if(isSuperArray(arr))
	{
		tempArr = [];
	
		for(i = 0; i < arr["length"]; i++)
		{
			obj = arr["values"][arr["keys"][i]];
			if( searchVal == obj[property])
			{
				tempArr[tempArr.size] = arr["keys"][i];
				if(!oneOrAll)
					return arr["keys"][i];
			}
		}
		if(tempArr.size > 0)
			return tempArr;
		return undefined;
	}
	tempArr = [];
	
	for(i = 0; i < arr.size; i++)
	{
		obj = arr[i];
		if( searchVal == obj[property])
		{
			tempArr[tempArr.size] = i;
			if(!oneOrAll)
				return i;
		}
	}
	if(tempArr.size > 0)
		return tempArr;
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
updateObjArrayByProperty(arr, value, property, searchVal, oneOrAll)
{
	if(!isDefined(oneOrAll))
		oneOrAll = false;
	
	if(isSuperArray(arr))
	{
		key = searchObjArrayByProperty(arr, property, searchVal, oneOrAll);
		
		if(!oneOrAll) //only update first matching index
		{
			if(isDefined(key))
				arr["values"][key][property] = value;
			else
			{
				tempArr = [];
				tempArr[property] = value;
				arr = arrayPush(arr, tempArr);
			}
			return arr;
		}	//update all matching indices
		if(isDefined(key))
		{
			for(i = 0; i < key.size; i++)
				arr["values"][key[i]][property] = value;
		}
		else
		{
			tempArr = [];
			tempArr[property] = value;
			arr = arrayPush(arr, tempArr);
		}
		return arr;	
	}
	
	index = searchObjArrayByProperty(arr, property, searchVal);
	
	if(!oneOrAll) //only update first matching index
	{
		if(isDefined(index))
			arr[index][property] = value;
		else
		{
			tempArr = [];
			tempArr[property] = value;
			arr = arrayPush(arr, tempArr);
		}
		return arr;
	} //update all matching indices
	if(isDefined(index))
	{
		for(i = 0; i < index.size; i++)
			arr[index[i]][property] = value;
	}
	else
	{
		tempArr = [];
		tempArr[property] = value;
		arr = arrayPush(arr, tempArr);
	}
	return arr;
}

/* *************************************************************************************************
**** superArray( array keys, array values )
****
**** USAGE: creates a keyed array with an array of keys and an array of values. Either empty if items
**** if it isn't passed anything or if passed an array of keys and values, it will start with them
****
**** returns the super array
****  
************************************************************************************************* */
superArray(keys, values)
{
	if(!isDefined(keys))
		keys = [];
	if(!isDefined(values))
		values = [];
	superArray = [];
	
	superArray["keys"] = keys;
	superArray["values"] = [];
	for(i = 0; i < superArray["keys"].size; i++)
	{
		if(isDefined(values[i]))
			superArray["values"][superArray["keys"][i]] = values[i];
		else //leave value undefined if we have more keys than values
			superArray["values"][superArray["keys"][i]] = undefined;
	} //if we have less keys than values, add a synthetic key
	for(; i < superArray["values"].size; i++)
	{
		//add synthetic key
		superArray["keys"][i] = superArray["keys"].size;
		superArray["values"][i] = values[i];
	}
	superArray["length"] = i;
	return superArray;
}

isSuperArray(arr)
{
	if(isDefined(arr) && isDefined(arr["keys"]) && isDefined(arr["values"]) && isDefined(arr["length"]))
		return true;
	else
		return false;
}

getArrayLength(arr)
{
	if(isSuperArray(arr))
		return arr["length"];
	return arr.size;
}

getValue(arr, key)
{
	if(isSuperArray(arr))
		if(isDefined(arr["values"][key]))
			return arr["values"][key];
		else
			return undefined;
	else
		if(isDefined(arr[key]))
			return arr[key];
		else
			return undefined;
}

updateValue(arr, key, value)
{
	if(isSuperArray(arr))
	{
		if(isDefined(arr["values"][key]))
		{
			arr["values"][key] = value;
			return arr;
		}
		else
			return arr;
	}
	else 
	{
		if(isDefined(arr[key]))
		{
			arr[key] = value;
			return arr;
		}
		else
			return arr;
	}
}
updateProperty(arr, key, property, value)
{
	if(isSuperArray(arr))
	{
		if(isDefined(arr["values"][key]))
		{
			if(isDefined(arr["values"][key][property]))
			{
				arr["values"][key][property] = value;
				return arr;
			}
			else
				return arr;
		}
		else
			return arr;
	}
	else 
	{
		if(isDefined(arr[key]))
		{
			if(isDefined(arr[key][property]))
			{
				arr[key][property] = value;
				return arr;
			}
			else
				return arr;
		}
		else
			return arr;
	}
}

getNextValue(arr, startIndex)
{
	if(!isDefined(startIndex) || startIndex < -1)
		startIndex = -1;
	if(isSuperArray(arr))
	{
		if(isDefined(arr["keys"][startIndex + 1]))
			return arr["values"][arr["keys"][startIndex + 1]];
		else
			return undefined;
	}
	else
	{
		if(isDefined(arr[startIndex + 1]))
			return arr[startIndex + 1];
		else
			return undefined;
	}
}

getArrayKeys(arr)
{
	if(isSuperArray(arr))
		return arr["keys"];
	else
		return undefined;
}

removeArrayKey(arr, key)
{
	if(!isSuperArray(arr))
		return arr;
	j = undefined;
	for(i = 0; i < arr["length"]; i++)
	{
		if(arr["keys"][i] == key)
		{
			j = i;
			break;
		}
	}
	if(!isDefined(j))
		return arr;

	for(i = j; i < arr["length"] - 1; i++)
		arr["keys"][i] = arr["keys"][ i + 1 ];

	arr["keys"][arr["length"] - 1] = undefined;
	arr["values"][key] = undefined;
	arr["length"] = arr["length"] - 1;

	return arr;
}

arrayForEach(arr, callback)
{
	if(!isSuperArray(arr))
		return arr;
	
	keys = getArrayKeys(arr);
	for( i = 0; i < arr["length"]; i++)
	{
		key = arr["keys"][i];
		item = arr["values"][key];
		item = [[callback]](item);
		arr["values"][key] = item;
	}
	return arr;
}

arrayReadEach(arr, callback)
{
	if(!isSuperArray(arr))
		return;
	keys = getArrayKeys(arr);
	for( i = 0; i < arr["length"]; i++)
	{
		key = arr["keys"][i];
		item = arr["values"][key];
		[[callback]](item);
	}
}

getNextKey(arr, startIndex)
{
	if(!isDefined(startIndex) || startIndex < -1)
		startIndex = -1;
	if(isSuperArray(arr))
	{
		if(isDefined(arr["keys"][startIndex + 1]))
			return arr["keys"][startIndex + 1];
		else
			return undefined;
	}
	else
	{
		if(isDefined(arr[startIndex + 1]))
			return startIndex + 1;
		else
			return undefined;
	}
}