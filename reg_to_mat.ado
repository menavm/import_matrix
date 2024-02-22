/**********************************************************
 menavm9@gmail.com
 1/22/24
 
 REG_TO_MAT.ADO: Output Regression to column of a matrix and merges onto the existing matrix
 
 Note: must run after regression
 
 **********************************************************/
 
program reg_to_mat
	syntax, mat(str) indvars(str) depvar(str) 
	capture matrix drop `tab'temp
	local vars_inreg : colfullnames e(b) 
	foreach tab in `mat' {
		tempvar mean_sample
		gen `mean_sample' = e(sample) 
		foreach k in `indvars' {	
			local ind = 0
			foreach var in `vars_inreg' {
				if "`k'" == "`var'" {
					local ind = `ind'+1
				}
		}
		
		if `ind'>0 {
			local b = _b[`k']
			local se = _se[`k']
			local t = _b[`k'] / _se[`k']
			local pval =  2*ttail(e(df_r), abs(`t'))
			mat `tab'temp = nullmat(`tab'temp) \ `b' \ `se' \ `pval'
			replace `mean_sample' =0 if `k'==1
		}
		else {
			mat `tab'temp = nullmat(`tab'temp) \ 9999 \ 9999 \ 9999
		}
		}
		
		local reg_sample = e(N)
		local rsquared =  e(r2) 
		quietly sum `depvar' if `mean_sample'==1
		local untreated_mean = r(mean)
		mat `tab'temp = nullmat(`tab'temp) \ `rsquared'\ `untreated_mean'\ `reg_sample' 
		
		mat `tab' = nullmat(`tab') , `tab'temp
		
		matrix drop `tab'temp
		drop `mean_sample'
	}
end