module SessionsHelper

  def current_user
    tmp = CurrentUser.find(1).cur
    tmp.present? ? User.find(tmp) : nil
  end

  def login(user)
    CurrentUser.find(1).update_attributes(cur: user.id)
  end

  def logout
    CurrentUser.find(1).update_attributes(cur: nil)
  end
end
