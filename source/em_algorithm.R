


#################################
# E-M Algorithm 

em_alg <- function(Y, delta, lambda0 = 0.001, tol = 1e-8, max_iter = 2500){

	n <- length(Y)
	m <- sum(delta)
	sumY <- sum(Y)

	# initiate
	lambda <- lambda0 

	converged <- FALSE

	# loop
	for (k in 1:max_iter){
		iter <- k

		# update
		lambda_new <- n / ( (n-m)/lambda + sumY  )

		# get difference
		lambda_diff <- lambda_new - lambda

		# update
		lambda <- lambda_new

		# check convergence
		if(abs(lambda_diff) < tol){
			converged <- TRUE
			break
		}
	}

	# get CI
	ci <- get_ci_em(lambda, delta)

	results <- list(
		lambda0 = lambda0,
		lambda = lambda,
		converged = converged,
		iter = iter, 
		ci = ci)

	return(results)

}


#################################
# confidence interval

get_ci_em <- function(lambda, delta, alpha = 0.05){

	# se from variance matrix
	# var(lambda) = lambda^2/sum(delta)
	se <- lambda / sqrt(sum(delta))

	# z for ci calc
	z <- c(-1, 1) * qnorm(1 - alpha/2)

	# ci vector
	ci <- setNames(exp(log(lambda) + z * se), c('2.5 %', '97.5 %'))

	return(ci)
}




