class AddressesController < ApplicationController
  def edit
    contact = FindContact.new.call(params[:contact_id])
    render :edit_with_error and return if contact.nil?

    addresses = LookupPostcode.new.call(contact.fetch('postcode'))
    if addresses.any?
      render :edit_with_address_select, locals: { addresses: addresses }
    else
      render :edit_with_manual_address_entry
    end
  end
end
