
func_time <- function(x){
	system.time(x)[['elapsed']]
}



#################################
# used by multiple functions

get_ci_logistic <- function(theta, H = NULL, invH = NULL, alpha = 0.05){

	# don't invert H unneccessarily
	if ( is.null(invH) ){
		invH <- matlib::inv(H)
	}

	# se from variance matrix
	se <- sqrt(diag(-invH))

	# z for ci calc
	z <- c(-1, 1) * qnorm(1 - alpha/2)

	# ci dataframe
		ci <- t(data.frame(
		'beta0' = theta[1] + z * se[1],
		'beta1' = theta[2] + z * se[2]))
	colnames(ci)  <- c('2.5 %', '97.5 %')

	return(ci)
}

#################################
# Newton's method

newton_method <- function(X, Y, theta0 = c(0,0), tol = 1e-8, max_iter = 250){

	# start time
	time_start <- proc.time()[['elapsed']]

	# initiate theta
	theta <- matrix(NA, ncol = 2, nrow = max_iter + 1)

	# initial value
	theta[1, ] <- theta0

	converged <- FALSE
	# loop
	for (k in 1:max_iter){

		iter <- k

		# gradient and hessian
		g <- grad_loglik(theta[k, ], X, Y)
		H <- hess_loglik(theta[k, ], X)

		# get theta k+1
		invH <- matlib::inv(H)
		theta[k+1,] <- theta[k,] - invH %*% g

		# check convergence
		if (max(abs(theta[k+1,] - theta[k, ])) < tol){
			converged <- TRUE
			break
		}
	}
	
	# get confidence interval
	ci <- get_ci_logistic(theta = theta[iter, ], invH = invH)

	# total time
	time <- proc.time()[['elapsed']] - time_start

	results <- list(
		theta = theta[iter, ], 
		iter = iter, 
		converged = converged, 
		ci = ci, 
		time = time)

	return(results)
}


#################################
# MM method

mm_method <- function(X, Y, theta0 = c(0, 0), tol = 1e-8, max_iter = 250, max_iter_inner = 500) {
	# start time
	time_start <- proc.time()[['elapsed']]

	n <- nrow(X)
	p <- ncol(X)

	# initial value
	theta_k <- theta0

	converged <- FALSE

	# loop
	for (k in 1:max_iter){
		iter <- k

		eta_k <- as.vector(X %*% theta_k)
		pi_k <- invlogit(eta_k)

		theta_k_old <- theta_k

		# param loop
		for (j in 1:p){

			Xj <- X[, j]
			sumYXj <- sum(Y * Xj)
			theta_kj <- theta_k[j]

			# inner loop
			for (l in 1:max_iter_inner){
				
				exp_term <- exp(p * Xj * (theta_kj - theta_k[j]))
				d1g <- - sum(pi_k * Xj * exp_term) + sumYXj # numerator
				d2g <- - p * sum(pi_k * Xj^2 * exp_term) # denomenator

				# get new value
				theta_kj_new <- theta_kj - d1g / d2g

				# get difference
				abs_diff <- abs(theta_kj_new - theta_kj)

				# update value
				theta_kj <- theta_kj_new

				# check if inner converge
				if (abs_diff < tol){
					break
				}

			} # inner loop

			# update parameter
			theta_k[j] <- theta_kj_new

		} # param loop

		# check convergence
		if ( max(abs(theta_k - theta_k_old)) < tol){
			converged <- TRUE
			break
		}

	} # outer loop

	# get confidence interval
	H <- hess_loglik(theta_k, X)
	ci <- get_ci_logistic(theta = theta_k, H = H)

	# total time
	time <- proc.time()[['elapsed']] - time_start

	results <- list(
		theta = theta_k, 
		iter = iter, 
		converged = converged, 
		ci = ci, 
		time = time)

	return(results)
}


#################################
# glm() method

glm_method <- function(X, Y){

	# start time
	time_start <- proc.time()[['elapsed']]

	# make sure call accounts for intercept already being in the X vector
	fit_glm <- glm(Y ~ 0 + X, family = binomial())
	theta <- setNames(coef(fit_glm), c('beta0', 'beta1'))
	ci <- suppressMessages(confint(fit_glm))
	rownames(ci) <- c('beta0', 'beta1')

	# total time
	time <- proc.time()[['elapsed']] - time_start
	
	# summary(fit_glm)$coefficients
	results <- list(
		theta = theta, 
		iter = fit_glm$iter, 
		converged = fit_glm$converged, 
		ci = ci, 
		time = time)

	return(results)
}


#################################
# optim() method

optim_method <- function(X, Y, theta0 = c(0, 0), tol = 1e-8, max_iter = 250){

	# start time
	time_start <- proc.time()[['elapsed']]

	# do method
	fit_optim <- optim(theta0, 
		fn = function(theta){ - loglik(theta, X = X, Y = Y) },
		gr = function(theta){ - grad_loglik(theta, X = X, Y = Y) }, 
		method = 'BFGS',
		hessian = TRUE,
		control = list( 
			maxit = max_iter,
			reltol = tol
		)
	)

	theta <- setNames(fit_optim$par, c('beta0', 'beta1'))

	# optim returns negative hessian, must be neg before passed to get_ci_logistic
	ci <- get_ci_logistic(theta = theta, H = - fit_optim$hessian)

	# total time
	time <- proc.time()[['elapsed']] - time_start

	results <- list(
		theta = theta, 
		iter = fit_optim$counts[['function']], 
		# optim uses 0 for success, 1 and other vals for error
		converged = (fit_optim$convergence == 0), 
		ci = ci,
		time = time)

	return(results)
}




