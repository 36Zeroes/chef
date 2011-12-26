maintainer        "36 Zeroes Pty. Ltd."
maintainer_email  "anuj@36zeroes.com.au"
license           "Apache 2.0"
description       "Installs Zint Barcode library"
version           "2.3.0"

recipe "zint::source", "Installs zint package from source"

%w{ ubuntu debian}.each do |os|
  supports os
end