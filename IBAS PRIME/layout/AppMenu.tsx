/* eslint-disable @next/next/no-img-element */

import React, { useContext } from 'react';
import AppMenuitem from './AppMenuitem';
import { LayoutContext } from './context/layoutcontext';
import { MenuProvider } from './context/menucontext';
import Link from 'next/link';
import { AppMenuItem } from '@/types';

const AppMenu = () => {
    const { layoutConfig } = useContext(LayoutContext);

    const model: AppMenuItem[] = [
        {
            label: 'Home',
            items: [{ label: 'Dashboard', icon: 'pi pi-fw pi-home', to: '/' }]
        },
        {
            label: 'Inventory Control',
            items: [
                { label: 'Form Layout', icon: 'pi pi-fw pi-id-card', to: '/uikit/formlayout' },
                { label: 'Input', icon: 'pi pi-fw pi-check-square', to: '/uikit/input' },
                { label: 'Float Label', icon: 'pi pi-fw pi-bookmark', to: '/uikit/floatlabel' },
                { label: 'Invalid State', icon: 'pi pi-fw pi-exclamation-circle', to: '/uikit/invalidstate' },
                { label: 'Button', icon: 'pi pi-fw pi-mobile', to: '/uikit/button', class: 'rotated-icon' },
                { label: 'Table', icon: 'pi pi-fw pi-table', to: '/uikit/table' },
                { label: 'List', icon: 'pi pi-fw pi-list', to: '/uikit/list' },
                { label: 'Tree', icon: 'pi pi-fw pi-share-alt', to: '/uikit/tree' },
                { label: 'Panel', icon: 'pi pi-fw pi-tablet', to: '/uikit/panel' },
                { label: 'Overlay', icon: 'pi pi-fw pi-clone', to: '/uikit/overlay' },
                { label: 'Media', icon: 'pi pi-fw pi-image', to: '/uikit/media' },
                { label: 'Menu', icon: 'pi pi-fw pi-bars', to: '/uikit/menu', preventExact: true },
                { label: 'Message', icon: 'pi pi-fw pi-comment', to: '/uikit/message' },
                { label: 'File', icon: 'pi pi-fw pi-file', to: '/uikit/file' },
                { label: 'Chart', icon: 'pi pi-fw pi-chart-bar', to: '/uikit/charts' },
                { label: 'Misc', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' }
            ]
        },
        {
            label: 'Account Receivable',
            items: [
                { label: 'Free Blocks', icon: 'pi pi-fw pi-eye', to: '/blocks', badge: 'NEW' },
                { label: 'All Blocks', icon: 'pi pi-fw pi-globe', url: 'https://blocks.primereact.org', target: '_blank' }
            ]
        },
        {
            label: 'Account Payable',
            items: [
                { label: 'PrimeIcons', icon: 'pi pi-fw pi-prime', to: '/utilities/icons' },
                { label: 'PrimeFlex', icon: 'pi pi-fw pi-desktop', url: 'https://primeflex.org/', target: '_blank' }
            ]
        },
        {
            label: 'General Ledger',
            icon: 'pi pi-fw pi-briefcase',
            to: '/pages',
            items: [
                {
                    label: 'Landing',
                    icon: 'pi pi-fw pi-globe',
                    to: '/landing'
                },
                {
                    label: 'Auth',
                    icon: 'pi pi-fw pi-user',
                    items: [
                        {
                            label: 'Login',
                            icon: 'pi pi-fw pi-sign-in',
                            to: '/auth/login'
                        },
                        {
                            label: 'Error',
                            icon: 'pi pi-fw pi-times-circle',
                            to: '/auth/error'
                        },
                        {
                            label: 'Access Denied',
                            icon: 'pi pi-fw pi-lock',
                            to: '/auth/access'
                        }
                    ]
                },
                {
                    label: 'Crud',
                    icon: 'pi pi-fw pi-pencil',
                    to: '/pages/crud'
                },
                {
                    label: 'Timeline',
                    icon: 'pi pi-fw pi-calendar',
                    to: '/pages/timeline'
                },
                {
                    label: 'Not Found',
                    icon: 'pi pi-fw pi-exclamation-circle',
                    to: '/pages/notfound'
                },
                {
                    label: 'Empty',
                    icon: 'pi pi-fw pi-circle-off',
                    to: '/pages/empty'
                }
            ]
        },
        {
            label: 'Customer Service',
            items: [
                {
                    label: 'Submenu 1',
                    icon: 'pi pi-fw pi-bookmark',
                    items: [
                        {
                            label: 'Submenu 1.1',
                            icon: 'pi pi-fw pi-bookmark',
                            items: [
                                { label: 'Submenu 1.1.1', icon: 'pi pi-fw pi-bookmark' },
                                { label: 'Submenu 1.1.2', icon: 'pi pi-fw pi-bookmark' },
                                { label: 'Submenu 1.1.3', icon: 'pi pi-fw pi-bookmark' }
                            ]
                        },
                        {
                            label: 'Submenu 1.2',
                            icon: 'pi pi-fw pi-bookmark',
                            items: [{ label: 'Submenu 1.2.1', icon: 'pi pi-fw pi-bookmark' }]
                        }
                    ]
                },
                {
                    label: 'Submenu 2',
                    icon: 'pi pi-fw pi-bookmark',
                    items: [
                        {
                            label: 'Submenu 2.1',
                            icon: 'pi pi-fw pi-bookmark',
                            items: [
                                { label: 'Submenu 2.1.1', icon: 'pi pi-fw pi-bookmark' },
                                { label: 'Submenu 2.1.2', icon: 'pi pi-fw pi-bookmark' }
                            ]
                        },
                        {
                            label: 'Submenu 2.2',
                            icon: 'pi pi-fw pi-bookmark',
                            items: [{ label: 'Submenu 2.2.1', icon: 'pi pi-fw pi-bookmark' }]
                        }
                    ]
                }
            ]
        },
        {
            label: 'System Manager',
            items: [
                {
                    label: 'Maintain',
                    icon: 'pi pi-fw pi-bookmark',
                    items: [
                        {
                            label: 'User Master', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                        {
                            label: 'Assign Users for Single Right', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                        {
                            label: 'Workstations', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                    ]
                },
                {
                    label: 'Utility',
                    icon: 'pi pi-fw pi-bookmark',
                    items: [
                        {
                            label: 'Submenu 2.1',
                            icon: 'pi pi-fw pi-bookmark',
                            items: [
                                { label: 'Submenu 2.1.1', icon: 'pi pi-fw pi-bookmark' },
                                { label: 'Submenu 2.1.2', icon: 'pi pi-fw pi-bookmark' }
                            ]
                        },
                        {
                            label: 'Submenu 2.2',
                            icon: 'pi pi-fw pi-bookmark',
                            items: [{ label: 'Submenu 2.2.1', icon: 'pi pi-fw pi-bookmark' }]
                        }
                    ]
                }
            ]
        },
        {
            label: 'Job Order',
            items: [
                {
                    label: 'Maintenance',
                    icon: 'pi pi-fw pi-desktop',
                    items: [
                        {
                            label: 'Circuit Builder', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                        {
                            label: 'Lineman Master', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                        
                    ]
                },
                {
                    label: 'Transaction',
                    icon: 'pi pi-fw pi-bookmark',
                    items: [
                        {                            
                            label: 'Edit Circuit ID', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },                        
                        {                            
                            label: 'JO For Override', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                        {                            
                            label: 'JO Preparation', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                        {                            
                            label: 'JO Preparation (Analog to Digital STB)', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                        {                            
                            label: 'JO Preparation (Corporate)', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                        {                            
                            label: 'JO Monitoring', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                        {                            
                            label: 'JO Monitoring (Instalations, Extended Service,Etc.)', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                        {                            
                            label: 'JO Monitoring (Disconnection and Reactivation)', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                        {                            
                            label: 'JO Monitoring (VAS)', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                        {                            
                            label: 'Release J.O', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                        {                            
                            label: 'Release J.O (Corporate)', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                        {                            
                            label: 'JO Monitoring (Corporate)', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                        {                            
                            label: 'JO Monitoring (NMP)', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                        {
                            label:'',
                            seperator: true // ✅ This now works!
                        },
                        {                            
                            label: 'Contract Acceptance', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                        {                            
                            label: 'Cancelation of Contract Acceptance', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                        {                            
                            label: 'Prepare JO for ADS Subcribers', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                        {                            
                            label: 'RR Task Entry', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                        {                            
                            label: 'Push Items To JO Mobile (Manual)', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                        {                            
                            label: 'Push Job Order to Web (Manual)', icon: 'pi pi-fw pi-circle', to: '/uikit/misc' 
                        },
                        
                    ]
                },
                {
                    label: 'Report',
                    icon: 'pi pi-fw pi-bookmark',
                    items: [
                        {
                            label: 'Submenu 2.1',
                            icon: 'pi pi-fw pi-bookmark',
                            items: [
                                { label: 'Submenu 2.1.1', icon: 'pi pi-fw pi-bookmark' },
                                { label: 'Submenu 2.1.2', icon: 'pi pi-fw pi-bookmark' }
                            ]
                        },
                        {
                            label: 'Submenu 2.2',
                            icon: 'pi pi-fw pi-bookmark',
                            items: [{ label: 'Submenu 2.2.1', icon: 'pi pi-fw pi-bookmark' }]
                        }
                    ]
                }
            ]
        },
        {
            label: 'Fix Asset',
            items: [
                {
                    label: 'Submenu 1',
                    icon: 'pi pi-fw pi-bookmark',
                    items: [
                        {
                            label: 'Submenu 1.1',
                            icon: 'pi pi-fw pi-bookmark',
                            items: [
                                { label: 'Submenu 1.1.1', icon: 'pi pi-fw pi-bookmark' },
                                { label: 'Submenu 1.1.2', icon: 'pi pi-fw pi-bookmark' },
                                { label: 'Submenu 1.1.3', icon: 'pi pi-fw pi-bookmark' }
                            ]
                        },
                        {
                            label: 'Submenu 1.2',
                            icon: 'pi pi-fw pi-bookmark',
                            items: [{ label: 'Submenu 1.2.1', icon: 'pi pi-fw pi-bookmark' }]
                        }
                    ]
                },
                {
                    label: 'Submenu 2',
                    icon: 'pi pi-fw pi-bookmark',
                    items: [
                        {
                            label: 'Submenu 2.1',
                            icon: 'pi pi-fw pi-bookmark',
                            items: [
                                { label: 'Submenu 2.1.1', icon: 'pi pi-fw pi-bookmark' },
                                { label: 'Submenu 2.1.2', icon: 'pi pi-fw pi-bookmark' }
                            ]
                        },
                        {
                            label: 'Submenu 2.2',
                            icon: 'pi pi-fw pi-bookmark',
                            items: [{ label: 'Submenu 2.2.1', icon: 'pi pi-fw pi-bookmark' }]
                        }
                    ]
                }
            ]
        },
        
    ];

    return (
        <MenuProvider>
            <ul className="layout-menu">
                {model.map((item, i) => {
                    return !item?.seperator ? <AppMenuitem item={item} root={true} index={i} key={item.label} /> : <li className="menu-separator"></li>;
                })}

                {/* <Link href="https://blocks.primereact.org" target="_blank" style={{ cursor: 'pointer' }}>
                    <img alt="Prime Blocks" className="w-full mt-3" src={`/layout/images/banner-primeblocks${layoutConfig.colorScheme === 'light' ? '' : '-dark'}.png`} />
                </Link> */}
            </ul>
        </MenuProvider>
    );
};

export default AppMenu;
