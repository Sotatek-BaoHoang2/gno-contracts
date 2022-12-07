package hello

import (
	"std"

	"gno.land/p/grc/grc20"
	"gno.land/r/bar20"
	"gno.land/r/wgnot"
)

var (
	token0, token1 grc20.IGRC20
)

func init() {
	token0 = wgnot.GetGRC20()
	token1 = bar20.GetGRC20()
}

func swap(amount float64, zeroToOne bool) (out float64) {
	caller := std.GetCallerAt(2)
	pkgaddr := std.GetOrigPkgAddr()
	if amount <= 0 {
		panic("Amount is zero")
	}
	if zeroToOne {
		token0.tranferFrom(caller, pkgaddr, amount)
		out := calculateOut(amount, zeroToOne)
		token1.transfer(caller, out)
	} else {
		token1.tranferFrom(caller, pkgaddr, amount)
		out := calculateOut(amount, zeroToOne)
		token0.transfer(caller, out)
	}
	return out
}

func calculateOut(amount float64, zeroToOne bool) (out float64) {
	if zeroToOne {
		out = amount * 2
	} else {
		out = amount * 0.5
	}
	return out
}
