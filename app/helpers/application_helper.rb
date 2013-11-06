module ApplicationHelper
  def div_toggle(div, div1=nil)
    update_page do |page|
      page[div].toggle
      page[div1].toggle if div1
    end
  end
  
  def version_name(version_id)
    vname = Version::BUILD_VERSION_NAMES.assoc(version_id.to_i)
    return (vname ? [vname[0], vname[1]].join('-') : 'invalid')
  end
  
  def format_annot(qc=nil, annot=nil)
    if qc.blank? && annot.blank?
      annot_val = ' '
    elsif annot.blank?
      annot_val = qc 
    else
      annot_val = [qc, annot].join('/')
    end
    return annot_val
  end
  
  def break_clear(content=nil)
    out = '<br />'
    out << '<table class="break_clear" width="100%"><tr><td>'
    out << content if !content.nil?
    out << '</td></tr></table>'
    out
  end
end
