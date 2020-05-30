import * as React from 'react';
import { ComponentProvider } from 'react-native';
import { IWrappedComponent } from './ComponentWrapper';
export declare class Store {
    private componentsByName;
    private propsById;
    private componentsInstancesById;
    private wrappedComponents;
    updateProps(componentId: string, props: any): void;
    getPropsForId(componentId: string): any;
    clearComponent(componentId: string): void;
    setComponentClassForName(componentName: string | number, ComponentClass: ComponentProvider): void;
    getComponentClassForName(componentName: string | number): ComponentProvider | undefined;
    setComponentInstance(id: string, component: IWrappedComponent): void;
    getComponentInstance(id: string): IWrappedComponent;
    setWrappedComponent(componentName: string | number, wrappedComponent: React.ComponentClass<any>): void;
    hasRegisteredWrappedComponent(componentName: string | number): boolean;
    getWrappedComponent(componentName: string | number): React.ComponentClass<any>;
}
