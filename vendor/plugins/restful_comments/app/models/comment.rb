class Comment < ActiveRecord::Base
	
	# Comments are tree
	belongs_to :parent, :class_name => 'Comment', :foreign_key => 'parent_id'
  
  has_many :children, :class_name => 'Comment', :foreign_key => 'parent_id'  
	
	if defined? RestfulCitations
		# Имеет набор цитат
		acts_as_restful_citable
	end
	
	# Что-то прокомментировано
	belongs_to :commentable, :polymorphic => true
	
	# Написан каким-то пользователем
	belongs_to :user, :class_name => 'User'
	
	def commentable_path
		'/' + self[:commentable_type].tableize + '/' + self[:commentable_id].to_s
	end
	
	def before_create
		if !self[:parent_id].to_i.zero?
			self[:depth] = parent[:depth].to_i + 1
		else
			self[:depth] = 0
		end
	end
	
	# Применяет блок кода к каждому узлу дерева из списка
	def self.for_each( comments, &block )
		for_each_children( nil, comments, &block ).to_s
	end
	
	def descendants
		result = []
		for comment in self.children do
			result << comment
			result += comment.descendants
		end
		result
	end
	
	def to_html
		txt = self[:body].gsub( '<', '&lt;' ).gsub( '>', '&gt;' ).gsub( '\n','<br />' )
		
		return RedCloth.new( txt ).to_html
	end
	
	private
	
	# Применяет блок кода к акждому узлу дерева из списка, являющегося ребенком узла с заданным идентификатором
	def self.for_each_children( parent_id, nodes, &block )
		for node in nodes
			if node.parent_id.to_i == parent_id.to_i
				yield node
				for_each_children( node.id, nodes, &block )
			end
		end
	end
	
end
