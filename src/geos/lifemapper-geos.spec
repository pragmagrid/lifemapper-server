Summary: lifemapper-geos
Name: lifemapper-geos
Version: 3.5.0
Release: 0
License: University of California
Vendor: Rocks Clusters
Group: System Environment/Base
Source: lifemapper-geos-3.5.0.tar.gz
Buildroot: /state/partition1/workspace/lifemapper-server/src/geos/lifemapper-geos.buildroot




%description
lifemapper-geos
%prep
%setup
%build
printf "\n\n\n### build ###\n\n\n"
BUILDROOT=/state/partition1/workspace/lifemapper-server/src/geos/lifemapper-geos.buildroot make -f /state/partition1/workspace/lifemapper-server/src/geos/lifemapper-geos.spec.mk build
%install
printf "\n\n\n### install ###\n\n\n"
BUILDROOT=/state/partition1/workspace/lifemapper-server/src/geos/lifemapper-geos.buildroot make -f /state/partition1/workspace/lifemapper-server/src/geos/lifemapper-geos.spec.mk install
%files 
/opt/lifemapper/*

