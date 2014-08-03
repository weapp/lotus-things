
g=lambda a=0,c=0:a and'g'+c*'o'+a or(lambda a=0,c=c+1:g(a,c))

g=lambda a=0,c=0:a and'g'+c*'o'+a or(lambda a=0:g(a,c+1))

# g=lambda a=0,o='':a and 'g'+o+a or(lambda a=0:g(a,o+'o'))

if __name__ == "__main__":
    go = g()
    print g('al')
    print g()('al')
    print g()()('al')
    print g()()()('al')
    print go('al')




exit()

def g(suffix=None):
    def fun(suffix=None, extra="o"):
        fun.extra = fun.extra + extra if hasattr(fun, "extra") else extra
        return "g%s%s" % (fun.extra, suffix) if suffix else fun
    return fun(suffix, "") if suffix else fun(None, "")



go = g()
print g("al")
print g()("al")
print g()()("al")
print g()()()("al")
print g()()()()("al")
print go("al")


print "CLASS:"

class g(object):
    def __init__(self, suffix = "o"):
        self.suffix = str(self.__class__.__name__) + suffix

    def __call__(self, suffix="o"):
        self.suffix += suffix
        return self

    def __str__(self):
        return self.suffix

b = type("b", (g,), {})




class G(str):
    def __call__(self, right='o'):
        return G(self + right)

g = G('g')
b = G('b')



print g("al")
print g()("al")

print
print b()("nus:")
print g()
print g("0")("al")
