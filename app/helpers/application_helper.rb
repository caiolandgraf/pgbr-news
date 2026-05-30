module ApplicationHelper
  def profile_path(user)
    "/@#{user.username}"
  end

  def edit_profile_path(user)
    "/@#{user.username}/edit"
  end

  def profile_owner?(user)
    logged_in? && current_user == user
  end

  def time_ago_pt(time)
    return "" unless time

    distance = time_ago_in_words(time)
    "#{distance} atrás"
  end

  def auth_tab_class(tab)
    active = (tab == :login && controller_name == "sessions") ||
             (tab == :signup && controller_name == "users")

    base = "flex-1 rounded-md py-2.5 text-center text-sm font-medium transition-all"
    if active
      "#{base} bg-white text-zinc-900 shadow-sm dark:bg-zinc-900 dark:text-zinc-50"
    else
      "#{base} text-zinc-600 hover:text-zinc-900 dark:text-zinc-400 dark:hover:text-zinc-200"
    end
  end

  def auth_input_class
    "block w-full border-0 bg-transparent px-3 py-2.5 text-sm text-zinc-900 placeholder:text-zinc-400 focus:outline-none focus:ring-0 dark:text-zinc-100 dark:placeholder:text-zinc-600"
  end

  def auth_field_wrapper_class
    "flex overflow-hidden rounded-lg border border-zinc-300 bg-white shadow-sm focus-within:border-blue-500 focus-within:ring-2 focus-within:ring-blue-500/30 dark:border-zinc-700 dark:bg-zinc-900"
  end
end
