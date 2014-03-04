use "main.sml";

(* findFirstSolution brd
   TYPE: board -> board option
   PRE:  true
   POST: If brd is a solvable board return SOME brd'
         where brd' is a solved board compatible
         with brd.
   EXAMPLE: !!! TODO !!!
            I feel a need for a function converting a
            list of lists to a board...

   VARIANT: The sum of all possibility lists of brd,
            that is the sum of
                getCell brd x y
            for all x and y.
*)
fun findFirstSolution(brd: board) : board option =
    let
        val boardside = getBoardSide brd
        val coordinates = List.tabulate(boardside, fn n => n)
        (* smallerthan(a,b)
         TYPE: int list * int list -> bool
         PRE:  true
         POST: true if a has two elements and
               either b is a singleton or
                      a is shorter than b.
         EXAMPLE: smallerthan([1],[2,3]) = false
                  smallerthan([2],[3]) = false
                  smallerthan([1,2,3],[4,5]) = false
                  smallerthan([4,5],[6]) = true
                  smallerthan([7,8,9],[1,2,3,4]) = true
         *)
        fun smallerthan(newList: int list, oldList : int list) =
            let
                val newLen = List.length newList
                val oldLen = List.length oldList
            in
                newLen >= 2 andalso (oldLen = 1 orelse newLen < oldLen)
            end

        val coordinateOfSmallestList =
            List.foldl (fn (x,minimalSoFar) =>
                           List.foldl
                               (fn (y,(oldx,oldy)) =>
                                   case smallerthan(getCell brd x y,
                                                    getCell brd oldx oldy) of
                                       true  => (x,y)
                                     | false => (oldx,oldy))
                               minimalSoFar
                               coordinates)
                       (0,0)
                       coordinates
        val (smallx,smally) = coordinateOfSmallestList

        (* findFirstAux lst
         TYPE: int list -> board option
         PRE:  All members of lst must lie in [1,boardside]
         POST: If a solution exists return SOME sol where
               sol is a solution extending brd.
               Otherwise, return NONE
         EXAMPLE:  !TODO!
         VARIANT: The length of lst.
         *)
        fun findFirstAux [] = NONE
          | findFirstAux (possibleNum::tail)
            = (case findFirstSolution(setCell brd smallx smally possibleNum) of
                   SOME brd' => SOME brd'
                 | NONE      => findFirstAux tail)
               handle NotASolution => findFirstAux tail
    in

        case getCell brd smallx smally of
            [a] => SOME brd
          | lst => findFirstAux lst
    end
