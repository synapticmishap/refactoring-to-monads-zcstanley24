class AddressesController < ApplicationController
  def edit
    result = FindContact
      .new
      .call(params[:contact_id])
      .or { |error| render :edit_with_error and return }

    LookupPostcode
      .new
      .call(result.value!.fetch('postcode'))
      .fmap { |addresses| render :edit_with_address_select, locals: { addresses: addresses } }
      .or { render :edit_with_manual_address_entry }
  end
end
