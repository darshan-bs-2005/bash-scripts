#! /bin/bash

function greet() {
	echo " hi! $1 this is function"
}
greet "darshn"

add() {
	echo " sum $(( $1 + $2 ))"
}

substract() {
	echo " difference $(( $1 - $2 ))"
}

multiply() {
	echo " product $(( $1 * $2 ))"
}

add 10 20
substract 20 10
multiply 20 100
