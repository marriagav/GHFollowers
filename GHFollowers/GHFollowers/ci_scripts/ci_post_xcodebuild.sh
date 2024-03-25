#!/bin/sh

#  ci_post_xcodebuild.sh
#  SimpleHabit
#
#  Created by Miguel Arriaga Velasco on 26/12/23.
#

if [ "$CI_WORKFLOW" = "Alpha" ] || [ "$CI_WORKFLOW" = "Beta" ]; then
  pushd ..
    mkdir TestFlight
    pushd TestFlight
      for locale in en-GB en-US es-MX es-ES; do
        git fetch --deepen 3 && git log -3 --pretty=format:"%s" > WhatToTest.$locale.txt
      done
    popd
  popd
fi

if [ "$CI_WORKFLOW" = "Production" ]; then
  pushd ..
    fastlane upload_to_appstore ipa:$CI_APP_STORE_SIGNED_APP_PATH/$CI_PRODUCT.ipa bundle_id:$CI_BUNDLE_ID scheme:$CI_XCODE_SCHEME
  popd
fi
