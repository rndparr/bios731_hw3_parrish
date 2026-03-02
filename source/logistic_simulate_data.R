

# function to get yi given true pi_i
get_Y <- function(p){
	sample(0:1, 1, prob = c(1 - p, p))
}


# get simulated data
sim_data <- function(beta0 = 1, beta1 = 0.3, n = 200){

	# true theta
	theta_true <- c(beta0, beta1)

	# simulated from normal dist; also add intercept column
	X <- cbind(1, rnorm(n, 0, 1))

	# get eta=X^Tbeta
	eta <- as.vector(X %*% theta_true)

	# true probability vector
	p_true <- 1 / (1 + exp(-eta))

	# Y
	Y <- sapply(p_true, get_Y)

	# info to return
	dat <- list(
		n = n,
		theta_true = theta_true,
		p_true = p_true,
		X = X,
		Y = Y
		)

	return(dat)
}
