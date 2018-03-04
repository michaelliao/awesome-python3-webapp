
"""
A example to test the __metaclass__
* python3 use metaclass at class declaration with metaclass= ''
* python2 use __metaclass__ member to assign the metaclass

"""


class UpperAttrMetaclass(type):
    def __new__(upperattr_metaclass, future_class_name, future_class_parents, future_class_attr):
        print('type ', type(future_class_attr))
        print('params ', future_class_attr)
        attrs = [(name.upper(), value) for name, value in future_class_attr.items() if not name.startswith('__')] # if not name.startswith('__')]
        attrs.extend( [(name, value) for name, value in future_class_attr.items() if name.startswith('__')]) # if not name.startswith('__')]
        attrs = tuple(attrs)
        uppercase_attr = dict(attrs)

        print("before type:{} {}".format( type(future_class_attr), future_class_attr))
        for k, v in future_class_attr.items():
            print('before item is ', k, v)

        print("after type:{} {}".format(type(uppercase_attr), uppercase_attr))
        for k, v in uppercase_attr.items():
            print('after item is ', k, v)

        # 复用type.__new__方法
        # 这就是基本的OOP编程，没什么魔法
        return super(UpperAttrMetaclass, upperattr_metaclass).__new__(upperattr_metaclass, future_class_name, future_class_parents, uppercase_attr)

__metaclass__ = UpperAttrMetaclass

class Person(object, metaclass = UpperAttrMetaclass):
  __metaclass__ = UpperAttrMetaclass ## useless at python3
  bar = 0
  __name = "Person"
  def __init__(self):
     super(Person, self).__init__()
     #self.bar = 0
     self.__name = 'unknown'
     print("construct a person")

p1 = Person()
print( "has bar ", hasattr(p1, 'bar'))
print( "has BAR ", hasattr(p1, 'BAR'))
print( "has _PERSON__name ", hasattr(p1, '_PERSON__name'))
print( "has _PERSON__NAME", hasattr(p1, '_PERSON__NAME'))
