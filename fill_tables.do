/**********************************************************
 menavm9@gmail.com
 1/22/24
 
 FILL_TABLES.ADO: Store matrix in txt file and export matrix to a sheet in Excel file.
 
 Adapted from ECON213R class material
 
 **********************************************************/
 

program fill_tables
	syntax, mat(str) save_txt(str) save_excel(str) [sheetname(str)]

	if "`sheetname'"!="" {
		local x : word count `mat' 
		local y : word count `sheet'

		if `x'==`y' {	
			forval i = 1/`x'{
			
				local tab : word `i' of `mat'
				local sheet : word `i' of `sheetname'

				matrix list `tab'
				matrix_to_txt, saving(`save_txt'_`tab'.txt) replace mat(`tab') format(%20.6f) title(<tab:`tab'>)
				insheet using `save_txt'_`tab'.txt, clear
				export excel _all using "`save_excel'", firstrow(var) cell(C100) sheetmodify sheet(`sheet')
				}
			}
		else {
			di in red "sheetname and mat must be the same length"
		}
	}
	
	if "`sheetname'"==""  { 
		foreach tab in `mat' {
			matrix list `tab'
			matrix_to_txt, saving(`save_txt'_`tab'.txt) replace mat(`tab') format(%20.6f) title(<tab:`tab'>)
			insheet using `save_txt'_`tab'.txt, clear
			export excel _all using "`save_excel'", firstrow(var) cell(C100) sheetmodify sheet(`tab') 
		}
	}
	
end
