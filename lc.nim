import macros

type ListComprehension = object
var lc*: ListComprehension
 
macro `[]`*(lc: ListComprehension, x, t): expr =
  expectLen(x, 3)
  expectKind(x, nnkInfix)
  expectKind(x[0], nnkIdent)
  assert($x[0].ident == "|")
 
  result = newCall(
    newDotExpr(
      newIdentNode("result"),
      newIdentNode("add")),
    x[1])
 
  for i in countdown(x[2].len-1, 0):
    let y = x[2][i]
#    expectKind(y, nnkInfix)
    expectMinLen(y, 1)
    if y[0].kind == nnkIdent and $y[0].ident == "<-":
      expectLen(y, 3)
      result = newNimNode(nnkForStmt).add(y[1], y[2], result)
    else:
      result = newIfStmt((y, result))
 
  result = newNimNode(nnkCall).add(
    newNimNode(nnkPar).add(
      newNimNode(nnkLambda).add(
        newEmptyNode(),
        newEmptyNode(),
        newEmptyNode(),
        newNimNode(nnkFormalParams).add(
          newNimNode(nnkBracketExpr).add(
            newIdentNode("seq"),
            t)),
        newEmptyNode(),
        newEmptyNode(),
        newStmtList(
          newAssignment(
            newIdentNode("result"),
            newNimNode(nnkPrefix).add(
              newIdentNode("@"),
              newNimNode(nnkBracket))),
          result))))


proc isEven(x: int): bool =
  x mod 2 == 0
echo 10.isEven
echo lc[x | (x <- 1..10, x.isEven), int]
echo lc[x | (x <- 1..10, not isEven(x)), int]
echo lc[(a, b, c) | (a <- 1..10, b <- 1..10, c <- 1..10, c*c == a*a + b*b), tuple[a,b,c: int]]
