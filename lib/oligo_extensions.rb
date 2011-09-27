module OligoExtensions
  ###############################################################################################
  # get_id_from_oligo_name:                                                                     #
  # Method to determine id primary key, from oligo_name parameter                               #
  ###############################################################################################
  def get_id_from_oligo_name(oligo_name, curr_format=nil, return_fmt='s')
    curr_format ||= curr_oligo_format?(oligo_name)
    oligo_array   = oligo_name.split(/_/)
    oligo_num     = oligo_array[0].to_i
    
    # oligo name in old format and number extracted from name is <= 73, may not match id
    # 1_ to 73_ where enzyme does not contain 'gapfill', id = number
    # 1_ to 73_ where enzyme does contain 'gapfill', id = (number + 373)
    if curr_oligo_format?(oligo_name) || oligo_num > 73                          
      oligo_id     = oligo_num
    else
      oligo_id = (oligo_array[2] == 'gapfill' ? oligo_num + 373 : oligo_num) 
    end
    
    # return id as string, or integer, depending on parameter passed
    return (return_fmt == 's'? oligo_id.to_s : oligo_id)
  end
  
  ###############################################################################################
  # get_gene_from_oligo_name:                                                                   #
  # Method to determine gene code, from oligo_name parameter                                    #
  ###############################################################################################
  def get_gene_from_oligo_name(oligo_name, curr_format=nil)
    curr_format ||= curr_oligo_format?(oligo_name)
    
    if curr_format
      # new format.  allow for possibility of gene containing one or more '_' delimiters
      # first split oligo_name into two components using '_ROI_' delimiter
      # gene will be the remaining substring starting after the 4th delimiter,
      # in the first array element
      oligo_array1 = oligo_name.split(/_ROI_/)
      oligo_array2 = oligo_array1[0].split(/_/)
      gene_code    = oligo_array2[4..-1].join("_")   
    else
      # old format.  if enzyme code is in format 'enzyme_gapfill' then gene is 4th element in
      # array, otherwise 3rd element
      oligo_array = oligo_name.split(/_/)
      gene_code = (oligo_array[2] == 'gapfill' ? oligo_array[3] : oligo_array[2])
    end
    
    return gene_code
  end
  
  ###############################################################################################
  # curr_oligo_format?:                                                                         #
  # Method to determine whether oligo_name is in current format, or old format                  #
  ###############################################################################################
  def curr_oligo_format?(oligo_name)
    #Design versions < 3, have oligo names which do NOT have an id# which matches the id primary key.
    #  These versions have an oligo name with 5 components, with gene code in 3rd position, unless
    #  enzyme code contains 'gapfill' in which case gene is in the 4th position

    #Design versions >= 3, have oligo_names which DO include an id# which matches the id primary key.
    #  These versions have an oligo name with 8 components, with gene code in 5th position.  

    #Use count of '_' delimiters to determine which format oligo name has been passed in
    (oligo_name.count("_") > 6 ? true : false)
  end
  
end