#
# Copyright (C) 2020 muink
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=rgmac
PKG_VERSION:=1.1
PKG_RELEASE:=d4ef908

PKG_MAINTAINER:=muink <hukk1996@gmail.com>
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/muink/rgmac.git
PKG_SOURCE_VERSION:=d4ef9084c61057a3b44b20e4e021a18f1bb17851

PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/rgmac
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=A random MAC address generator
	URL:=https://github.com/muink/rgmac
	DEPENDS:=+bash +curl +coreutils-cksum +getopt
	PKGARCH:=all
endef

define Package/rgmac/conffiles
endef

define Package/rgmac/postinst
#!/bin/sh
rgmac -U
endef

define Package/rgmac/prerm
#!/bin/sh
rm -rf /usr/share/rgmac
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/rgmac/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/usr/share/rgmac
	$(INSTALL_DIR) $(1)/usr/share/rgmac/Vendor
	$(SED) 's,^\xEF\xBB\xBF,,g'                                                 $(PKG_BUILD_DIR)/Vendor/*
	$(SED) 's,\x0D,,g'                                                          $(PKG_BUILD_DIR)/Vendor/*
	$(SED) 's,WORKDIR=.* # <--,,'                                               $(PKG_BUILD_DIR)/rgmac
	$(SED) 's,OUIFILE=.* # <--,OUIFILE=/usr/share/rgmac/oui.txt,'               $(PKG_BUILD_DIR)/rgmac
	$(SED) 's,VENDORDIR=.* # <--,VENDORDIR=/usr/share/rgmac/Vendor/,'           $(PKG_BUILD_DIR)/rgmac
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/rgmac $(1)/usr/bin/rgmac
	$(CP) $(PKG_BUILD_DIR)/Vendor/* $(1)/usr/share/rgmac/Vendor/
endef


$(eval $(call BuildPackage,rgmac))
