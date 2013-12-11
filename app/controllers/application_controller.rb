class ApplicationController < Wnm::ApplicationController
  protect_from_forgery

  helper LayoutBannerHelper
  helper TagHelper
  helper Wnm::BannersHelper
  helper UserNavigationHelper
end
