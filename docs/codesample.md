# this is a comment
func main()::Void
     var a::Int32 = 5
     var ptr::Int32&
     ptr* = 5
     print(ptr*)
     
     var sum::Int = add(a, a) # returns 10

     if sum == 5
	    print("it did not work")
     elif sum == 10
	    print("did work")
     end

     var c::Int = 0
     var msg::String = "this is a message"
     while c <= 5
	    print(msg)	
	    c++
     end

     for i in 1:3
	    print(i)
     end

     var list::Array<Int> = [1 2 3 4 5]
     var undef::Array<Int>;
     print(list[2])
end

func add(a::Int, b::Int)::Int = a + b
