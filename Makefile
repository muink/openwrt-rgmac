#
# Copyright (C) 2020-2023 muink
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=rgmac
PKG_VERSION:=1.4.7
PKG_RELEASE:=20231028

PKG_MAINTAINER:=muink <hukk1996@gmail.com>
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/muink/rgmac.git
PKG_SOURCE_VERSION:=v$(PKG_VERSION)
PKG_MIRROR_HASH:=a38eb000f4343aee0e0e61c5b169578900730773675fdf710c48502747f31e78
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_SOURCE_VERSION).tar.gz
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	TITLE:=A random MAC address generator
	URL:=https://github.com/muink/rgmac
	DEPENDS:=+bash +curl +coreutils-cksum +getopt
	PKGARCH:=all
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/usr/share/rgmac
	$(INSTALL_DIR) $(1)/usr/share/rgmac/Vendor
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(SED) 's,^\xEF\xBB\xBF,,g'                                                 $(PKG_BUILD_DIR)/Vendor/*
	$(SED) 's,\x0D,,g'                                                          $(PKG_BUILD_DIR)/Vendor/*
	$(SED) 's,WORKDIR=.* # <--,,'                                               $(PKG_BUILD_DIR)/rgmac
	$(SED) 's,OUIFILE=.* # <--,OUIFILE=/usr/share/rgmac/oui.txt,'               $(PKG_BUILD_DIR)/rgmac
	$(SED) 's,VENDORDIR=.* # <--,VENDORDIR=/usr/share/rgmac/Vendor/,'           $(PKG_BUILD_DIR)/rgmac
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/rgmac $(1)/usr/bin/rgmac
	$(CP) $(PKG_BUILD_DIR)/Vendor/* $(1)/usr/share/rgmac/Vendor/
	$(INSTALL_BIN) ./uci-defaults $(1)/etc/uci-defaults/99_$(PKG_NAME)
endef

define Package/$(PKG_NAME)/conffiles
endef

define Package/$(PKG_NAME)/postinst
endef

define Package/$(PKG_NAME)/prerm
#!/bin/sh
rm -rf /usr/share/rgmac
endef


$(eval $(call BuildPackage,rgmac))
