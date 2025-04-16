import Form from '@/app/ui/invoices/edit-form';
import Breadcrumbs from '@/app/ui/invoices/breadcrumbs';
import { fetchCustomers, fetchInvoiceById } from '@/app/lib/data';
import { notFound } from 'next/navigation';
import { getDashboardPrefix } from '@/app/lib/utils';

export default async function Page(props: { params: Promise<{ id: string; }>; }) {
    const params = await props.params;
    const id = params.id;
    const [invoice, customers] = await Promise.all([
        fetchInvoiceById(id),
        fetchCustomers()
    ]);
    const dashboardPrefix = await getDashboardPrefix();

    if (!invoice) {
        notFound();
    }

    return (
        <main>
            <Breadcrumbs
                breadcrumbs={[
                    { label: 'Invoices', href: `/${dashboardPrefix}/dashboard/invoices` },
                    {
                        label: 'Edit Invoice',
                        href: `/${dashboardPrefix}/dashboard/invoices/invoices/${id}/edit`,
                        active: true,
                    },
                ]}
            />
            <Form invoice={invoice} customers={customers} />
        </main>
    );
}