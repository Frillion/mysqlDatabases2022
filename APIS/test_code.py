def dangerous_function():
    print('Oh Shit')

def some_funtion(suck,**kwargs):
    print(kwargs.get('a'))

def replace(re,wit,list):
    for i in range(len(list)):
        if list[i] == re:
            list[i] = wit
randomlist = ['sadfsadf','None',1231]

replace('None',None,randomlist)

print(randomlist)