
# inverse logit function/sigmoid function
invlogit <- function(eta){
	p <- 1 / (1 + exp(-eta))
	return(p)
}


# logistic loglikelihood
loglik <- function(theta, X, Y){
	eta <- as.vector(X %*% theta)
	l <- sum(Y * eta - log1p(exp(eta)))
	return(l)
}


# logistic gradient
grad_loglik <- function(theta, X, Y){
	eta <- as.vector(X %*% theta)
	grad_l <- crossprod(X, Y - invlogit(eta))
	return(as.vector(grad_l))
}


# logistic hessian
hess_loglik <- function(theta, X){
	eta <- as.vector(X %*% theta)
	p <- invlogit(eta)
	hess_l <- - crossprod(p*(1-p) * X, X)
	return(hess_l)
}

