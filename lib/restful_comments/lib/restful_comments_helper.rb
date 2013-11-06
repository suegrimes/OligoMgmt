
module RestfulComments
	module Helper
		
		def restful_comments_include( options = {} )
			result = ''
			
			if options && options[:stylesheet]
				result += stylesheet_link_tag options[:stylesheet].to_s
			elsif options && options[:style]
				result += stylesheet_link_tag 'style_' + options[:style].to_s, :plugin => 'restful_comments'
			else
				result += stylesheet_link_tag 'style_gray', :plugin => 'restful_comments'
			end
			
			result += javascript_include_tag 'comments', :plugin => 'restful_comments'
			
			return result
		end
		
		def restful_comments_for( commentable )
			render :partial => 'comments/comments', :locals => { :commentable => commentable }
		end
	end
end
