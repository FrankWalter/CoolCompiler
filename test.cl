-- this is just a test
(* models one-dimensional cellular automaton on a circle of finite radius
   arrays are faked as Strings,
   X's respresent live cells, dots represent dead cells,
   no error checking is done *)
class Main inherits A2I {
	main() : Object {
		(new IO).out_string(i2a(fact(a2i((new IO).in_string()))).concat("\n"))
	};
	fact(i: Int): Int {
		let fact: Int <- 1 in {
			while (not (i = 0)) loop
				{
					fact <- fact * i;
					i <- i - 1;
				}
			pool;
			fact;
		}
	};
};