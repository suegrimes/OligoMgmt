require 'restful_comments_commentable'
require 'restful_comments_helper'

ActiveRecord::Base.send :include, RestfulComments::Commentable
ActionView::Base.send :include, RestfulComments::Helper