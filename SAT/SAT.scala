

trait Expr {
	def simplify(): Expr
	def factorise(): Expr
	def develop(): Expr
}

case class Var(name: String) extends Expr {
	def simplify(): Expr = Var(name)
	def factorise(): Expr = Var(name)
	def develop(): Expr = Var(name)
}

case class Not(e: Expr) extends Expr {
	def simplify(): Expr = child match {
		case Var(name) => Not(Var(name))
		case Not(e) => e
		case And(es) => Or(es map {e => Not(e).simplify()})
		case Or(es) => And(es map {e => Not(e).simplify()})
	}
	def factorise(): Expr = ???
	def develop(): Expr = ???
}

case class And(es: List[Expr]) extends Expr {
	def simplify(): Expr = {
		def it(xs: List[Expr], newxs: List[Expr]): List[Expr] = xs match {
			case And(es) :: xss => it(xss, (es map simplify) ::: newxs)
			case x :: xss => it(xss, x.simplify() :: newxs)
			case Nil => newxs
		}
		And(it(es, Nil))
	}
	def factorise(): Expr = ???
	def develop(): Expr = ???
}

case class Or(es: List[Expr]) extends Expr {
	def simplify(): Expr = {
		def it(xs: List[Expr], newxs: List[Expr]): List[Expr] = xs match {
			case Or(es) :: xss => it(xss, (es map simplify) ::: newxs)
			case x :: xss => it(xss, x.simplify() :: newxs)
			case Nil => newxs
		}
		Or(it(es, Nil))
	}
	def factorise(): Expr = ???
	def develop(): Expr = ???
}

object Sat {
	def main(args: Array[String]): Unit = {
		val e: Expr = Var("test")
		print(e.factorise())
		print(e.develop())
	}
}

