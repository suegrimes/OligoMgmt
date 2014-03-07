# Authorization rules, using authorization gem: "cancan"
# Add the following code in all controllers for which authorization should apply:
#   load_and_authorize_resource

# Any common non-RESTful actions across controllers can be mapped to a standard action such
# as 'read' using 'alias_action', below.
# Alternatively, can restrict access within a specific controller method with:
#   authorize! :action, model_object

# In views, to test whether the current user has permissions to perform a given 'action' on a
# specific 'model_object', use:
#    if can? :action, model_object

# rescue clause for unauthorized actions, is in application controller.

class Ability
  include CanCan::Ability

  def initialize(user=current_user)
    alias_action :new_query, :index, :show, :export_design, :export_oligos, :to => :read

    # Everyone can read all data, except user information for other users
    can :read, :all

    # Everyone can create a new user, or view/edit their own user information
    can [:new, :create, :forgot, :reset], User
    can [:show, :edit, :update], User do |usr|
      (user.has_role?("admin")? true : usr.login == user.login)
    end

    return nil if user == :false

    # Admins have access to all functionality
    if user.has_role?("admin")
      can :manage, :all
    else
      can :manage, [OligoDesign, PilotOligoDesign, PlateTube, PlatePosition, Pool, SynthOligo,
                      StorageLocation, Vector, Version]
      can :index, Researcher
    end
  end
end