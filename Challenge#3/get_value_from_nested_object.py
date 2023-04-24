#Function that accepts 2 arguments nested_object and key
def get_value_from_nested_object(nested_object, key):
    if key in nested_object:
        return nested_object[key]
    for k, v in nested_object.items():
        if isinstance(v, dict):
            result = get_value_from_nested_object(v, key)
            if result is not None:
                return result
    return None

#Example usage of the function
my_nested_object = {
    'a': 'b',
    'c': {
        'd': 'e',
        'f': 'g'
    }
}

my_key = 'c'
my_key1 = 'd'
result = get_value_from_nested_object(my_nested_object, my_key)
result1 = get_value_from_nested_object(my_nested_object, my_key1)
print(result)
print(result1)