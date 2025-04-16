import Form from "@/app/ui/invoices/create-form";
import { fetchCustomers } from "@/app/lib/data";
import Breadcrumbs from "@/app/ui/invoices/breadcrumbs";
import { getDashboardPrefix } from "@/app/lib/utils";

export default async function Page() {
    const customers = await fetchCustomers();
    const dashboardPrefix = await getDashboardPrefix();

    return (
        <main>
            <Breadcrumbs
                breadcrumbs={[
                    {
                        label: 'Invoices',
                        href: `/${dashboardPrefix}/dashboard/invoices`
                    },
                    {
                        label: 'Create Invoice',
                        href: `/${dashboardPrefix}/dashboard/invoices/create`,
                        active: true
                    }
                ]}
            />
            <Form customers={customers} />
        </main>
    );
}